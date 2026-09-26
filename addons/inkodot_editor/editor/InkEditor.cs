using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Godot;
using Ink;
using GodotInkle;

namespace InkodotEditor;

using GC = Godot.Collections;

[Tool]
public sealed partial class InkEditor : CodeEdit
{
	[Export] public string MainFolder = "/ink/";
	[Export(PropertyHint.File, "*.ink")] public string? FilePath;

	[ExportSubgroup("Ink Files")]
	[Export] public InkStory? CurrentStory;

	[ExportSubgroup("Nodes")]
	[Export] public Control? DialogueNode;

	[ExportSubgroup("Readonly")]
	[Export] public string Title = "...";

	[Export] public GC.Dictionary<string, string> StoriesSaveCache = [];

	[Export] public GC.Dictionary<int, string> Errors = [];
	[Export] public GC.Dictionary<int, string> Warnings = [];

	[Signal] public delegate void OnTextUpdatedEventHandler();
	[Signal] public delegate void SaveStateModifiedEventHandler();

	public List<int> ChoiceHistoryList = [];
	public bool IsUpdating;

	readonly HashSet<int> ColoredLines = [];

	// todo -> 1. Search, 2. Adding new File



	//> Main

	public override void _Ready()
	{
		if (Engine.IsEditorHint()) return;

		try
		{
			ProjectSettings.SetSetting("application/run/low_processor_mode", true);

			// Standalone builds default to <executable_dir>/ink/ so the editor has
			// a writable home next to the binary. The plugin, running inside the
			// Godot editor, keeps its previous res:// default.
			if (MainFolder.IsNullOrEmpty() || MainFolder == "res://")
			{
				MainFolder = GetStandaloneRoot();
			}

			CreateMenu();

			TextChanged += () => Update().Forget();
			Update(true).Forget();
		}

		catch (Exception ex)
		{
			GD.PrintErr($"{ex}");
		}
	}

	/// <summary>
	/// Resolves the folder the standalone editor uses as its home. Prefers
	/// &lt;exe_dir&gt;/ink/; falls back to &lt;user_data_dir&gt;/ink/ when the
	/// executable directory is unusable (e.g. running under the Godot editor,
	/// or installed to a read-only location).
	/// </summary>
	static string GetStandaloneRoot()
	{
		var exePath = OS.GetExecutablePath();
		GD.Print($"[Inkodot] Executable path: '{exePath}'");

		var exeDir = exePath.GetBaseDir();

		// macOS .app bundles: walk out of Contents/MacOS/ so we don't try to
		// write inside the bundle. Guard on GetFile() so a non-bundle path
		// never triggers the walk.
		if (OS.HasFeature("macos") && exeDir.GetFile() == "MacOS")
		{
			exeDir = exeDir.GetBaseDir().GetBaseDir().GetBaseDir();
			GD.Print($"[Inkodot] macOS bundle detected, walked out to: '{exeDir}'");
		}

		// Sanity: the resolved dir must be an absolute path that actually exists,
		// and must not be the filesystem root (which usually means we walked too
		// far, or GetBaseDir() returned nothing useful).
		var exeDirValid =
			!exeDir.IsNullOrEmpty() &&
			exeDir != "/" &&
			exeDir.IsAbsolutePath() &&
			DirAccess.DirExistsAbsolute(exeDir);

		if (!exeDirValid)
		{
			GD.PushWarning(
				$"[Inkodot] Executable directory is unusable (got '{exeDir}'). " +
				"Falling back to user data directory.");

			var fallback = OS.GetUserDataDir().PathJoin("ink");
			DirAccess.MakeDirRecursiveAbsolute(fallback);
			return fallback;
		}

		var root = exeDir.PathJoin("ink");

#if DEBUG
		GD.Print($"[Inkodot] Using root folder: '{root}'");
#endif

		if (!DirAccess.DirExistsAbsolute(root))
		{
			var err = DirAccess.MakeDirRecursiveAbsolute(root);
			if (err != Error.Ok)
			{
				GD.PushWarning(
					$"[Inkodot] Could not create {root} (error {err}). " +
					"Falling back to user data directory.");

				var fallback = OS.GetUserDataDir().PathJoin("ink");
				DirAccess.MakeDirRecursiveAbsolute(fallback);
				return fallback;
			}
		}

		return root;
	}

	public async Task Update(bool newFile = false)
	{
		while (IsUpdating)
			await Task.Delay(200);

		IsUpdating = true;

		ClearLinesBG();
		ClearStoryPage();

		LoadInkText();

		Title = Path.GetFileName(FilePath) ?? "...";

		if (newFile) StartDialogue();
		else LoadDialogue();

		IsUpdating = false;
		EmitSignal(SignalName.OnTextUpdated);
	}

	public void ChooseChoiceIndex(int index, bool saveChoice)
	{
		CurrentStory?.ChooseChoiceIndex(index);

		if (saveChoice)
		{
			ChoiceHistoryList.Add(index);
		}
	}

	/// <summary>
	/// Detach the editor from the current file and clear all associated state.
	/// Used when the file's containing folder is deleted, so FilePath doesn't
	/// keep pointing at a path that no longer exists.
	/// </summary>
	public void ClearFile()
	{
		// Drop any cached edits — otherwise SaveSession would try to write them
		// back to disk on the next run.
		if (!FilePath.IsNullOrEmpty())
			StoriesSaveCache.Remove(FilePath);

		ClearLinesBG();

		// Assign Text before nulling FilePath. Setting Text triggers TextChanged,
		// which schedules Update(); Update() sees empty Text and bails early,
		// leaving CurrentStory = null (see LoadInkText above).
		Text = "";

		FilePath = null;
		CurrentStory = null;
		Title = "...";
		ChoiceHistoryList.Clear();
		Errors.Clear();
		Warnings.Clear();

		if (!DialogueNode.Invalid())
			DialogueNode.CallDeferred("clear");

		EmitSignal(SignalName.OnTextUpdated);
	}

	void ClearStoryPage()
	{
		Errors.Clear();
		Warnings.Clear();
		Title = "";
	}

	void StartDialogue()
	{
		if (DialogueNode.Invalid()) return;

		ChoiceHistoryList.Clear();

		if (CurrentStory is null)
		{
			DialogueNode.CallDeferred("clear");
			return;
		}

		DialogueNode.CallDeferred("start", CurrentStory);
	}

	async void LoadDialogue()
	{
		if (DialogueNode.Invalid()) return;

		if (CurrentStory is null)
		{
			DialogueNode.CallDeferred("clear");
			return;
		}

		DialogueNode.CallDeferred("load_choices", CurrentStory, GetChoiceHistory());
	}

	void LoadInkText()
	{
		if (Text.IsNullOrEmpty())
		{
			CurrentStory = null;
			return;
		}

		try
		{
			CurrentStory = CompileStory(FilePath);
			CurrentStory?.Initialize();
		}

		catch (Exception ex)
		{
			CurrentStory = null;
			Errors[0] = $"{ex}";
		}
	}



	//> Choice History

	int[] GetChoiceHistory() => [.. ChoiceHistoryList];

	void SetChoiceHistory(int[] newHistory) => ChoiceHistoryList = [.. newHistory];



	//> File

	public void SetRootDir(string path)
	{
		MainFolder = path;
	}

	public void SetNewFile(string? path)
	{
		try
		{
			CacheCurrentStory();
			FilePath = path;

			if (!FilePath.IsNullOrEmpty())
			{
				if (StoriesSaveCache.TryGetValue(FilePath, out var text))
				{
					Text = text;
				}

				else
				{
					var globalPath = ProjectSettings.GlobalizePath(FilePath);
					Text = File.ReadAllText(globalPath);
				}
			}
		}

		catch (Exception ex)
		{
			GD.PushWarning($"{ex}");
		}

		Update(true).Forget();
	}



	//> Save - File

	public bool IsFileChanged(string path)
	{
		if (StoriesSaveCache.ContainsKey(path))
		{
			return true;
		}

		if (path != FilePath) return false;

		var globalPath = ProjectSettings.GlobalizePath(path);
		var text = File.ReadAllText(globalPath);

		return !text.Equals(Text, StringComparison.Ordinal);
	}

	public void RemoveFromCache(string path)
	{
		StoriesSaveCache.Remove(path);

		if (FilePath == path)
		{
			var globalPath = ProjectSettings.GlobalizePath(FilePath);
			Text = File.ReadAllText(globalPath);

			Update(true).Forget();
		}

		EmitSignal(nameof(SaveStateModified));
	}

	public void WriteFile(string? path)
	{
		if (MainFolder.IsNullOrEmpty()) return;
		if (path.IsNullOrEmpty()) return;

		try
		{
			var story = CompileStory(path);
			if (story is null) return;
		}

		catch (Exception ex)
		{
			GD.PushError($"{ex}");
		}

		string? text = null;

		if (path == FilePath)
		{
			text = Text;
		}

		else if (StoriesSaveCache.TryGetValue(path, out var storyText))
		{
			text = storyText;
		}

		if (text is null) return;

		StoriesSaveCache.Remove(path);

		var globalPath = ProjectSettings.GlobalizePath(path);
		File.WriteAllText(globalPath, text);

		EmitSignal(nameof(SaveStateModified));
	}

	void CacheCurrentStory()
	{
		if (FilePath.IsNullOrEmpty()) return;
		if (Text.IsNullOrEmpty()) return;

		var globalPath = ProjectSettings.GlobalizePath(FilePath);
		if (!File.Exists(globalPath)) return;

		var text = File.ReadAllText(globalPath);

		if (!text.Equals(Text, StringComparison.Ordinal))
		{
			StoriesSaveCache[FilePath] = Text;
		}
	}



	//> Save - Session

	public void DiscardSession()
	{
		StoriesSaveCache.Clear();

		if (!FilePath.IsNullOrEmpty())
		{
			var globalPath = ProjectSettings.GlobalizePath(FilePath);
			var text = File.ReadAllText(globalPath);
			Text = text;
		}

		EmitSignal(nameof(SaveStateModified));
	}

	public void SaveSession()
	{
		if (!FilePath.IsNullOrEmpty())
		{
			StoriesSaveCache[FilePath] = Text;
		}

		foreach (var pair in StoriesSaveCache)
		{
			var path = pair.Key;
			var text = pair.Value;

			try
			{
				var story = CompileStory(path);
				if (story is null)
				{
					GD.PushError($"Can't save {FilePath}!");
					return;
				}
			}

			catch (Exception ex)
			{
				GD.PushError($"{ex}");
			}

			var globalPath = ProjectSettings.GlobalizePath(path);
			File.WriteAllText(globalPath, text);
		}

		StoriesSaveCache.Clear();

		EmitSignal(nameof(SaveStateModified));
	}



	//> Syntax

	void ClearLinesBG()
	{
		foreach (var lineNum in ColoredLines)
		{
			if (GetLineCount() > lineNum)
				SetLineBackgroundColor(lineNum, Colors.Transparent);
		}

		ColoredLines.Clear();
	}



	//> Ink Compiler

	InkStory? CompileStory(string? path)
	{
		var options = new Compiler.Options
		{
			errorHandler = InkCompilerErrorHandler,
		};

		if (!path.IsNullOrEmpty() && Godot.FileAccess.FileExists(path))
		{
			var globalPath = ProjectSettings.GlobalizePath(path);
			var folder = Path.GetDirectoryName(globalPath);

			if (folder is not null)
			{
				options.sourceFilename = globalPath;
				options.fileHandler = new FileHandler(folder);
			}
		}

		var compiler = new Compiler(Text, options);
		var json = compiler?.Compile()?.ToJson();
		if (json is null) return null;

		return new InkStory(json);
	}

	class FileHandler(string rootDir) : IFileHandler
	{
		public string ResolveInkFilename(string includedFileNames)
			=> Path.Combine(rootDir, includedFileNames);

		public string LoadInkFileContents(string fullFileName)
			=> File.ReadAllText(fullFileName);
	}

	void InkCompilerErrorHandler(string message, ErrorType errorType)
	{
		var lineNumRegEx = RegEx.CreateFromString(@"(?<=line) \d*");
		var lineNumMatch = lineNumRegEx.Search(message);

		var messageRegEx = RegEx.CreateFromString(@"(line \d*: )\K.*");
		var messageStrMatch = messageRegEx.Search(message);

		if (errorType == ErrorType.Error)
		{
			var num = lineNumMatch.GetString().ToInt();

			if (!Warnings.ContainsValue(message))
			{
				Errors[num] = messageStrMatch?.GetString() ?? message;

				var color = new Color(1, 0, 0, 0.25f);
				CallDeferred(TextEdit.MethodName.SetLineBackgroundColor, num - 1, color);

				ColoredLines.Add(num - 1);
			}

			return;
		}

		if (errorType == ErrorType.Warning)
		{
			var num = lineNumMatch.GetString().ToInt();

			if (!Warnings.ContainsValue(message))
			{
				Warnings[num] = messageStrMatch?.GetString() ?? message;

				var color = new Color(1, 0.5f, 0, 0.25f);
				CallDeferred(TextEdit.MethodName.SetLineBackgroundColor, num - 1, color);

				ColoredLines.Add(num - 1);
			}

			return;
		}

	}
}
