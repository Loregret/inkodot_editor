#if TOOLS
#pragma warning disable IDE0022

using Godot;
using Ink;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Text.RegularExpressions;

using GC = Godot.Collections;
using CS = System.Collections.Generic;

using DependenciesCache = System.Collections.Generic.Dictionary<string, string[]>;
using System;

namespace GodotInkle;

[Tool]
public sealed partial class InkStoryImporter : EditorImportPlugin
{
	const string OPT_MAIN_FILE = "is_main_file";
	
	const string CACHE_FILE = "user://ink_cache.json";

	public override string[] _GetRecognizedExtensions() => ["ink"];
	
	public override string _GetImporterName() => "ink_story_importer";
	public override string _GetVisibleName() => "Ink Story";

	public override string _GetResourceType() => nameof(Resource);
	public override string _GetSaveExtension() => "res";

	public override int _GetPresetCount() => 0;
	public override int _GetImportOrder() => 0;
	
	public override float _GetPriority() => 1.0f;
	public override bool _GetOptionVisibility(string path, StringName optionName, GC.Dictionary options) => true;

	public override GC.Array<GC.Dictionary> _GetImportOptions(string path, int presetIndex) =>
	[
		new() { { "name", OPT_MAIN_FILE }, { "default_value", true } },
	];


	//> IMPORT()

	public override Error _Import(string sourceFile, string savePath, GC.Dictionary options, GC.Array<string> _, GC.Array<string> __)
	{
		string destFile = $"{savePath}.{_GetSaveExtension()}";
		bool isMainFile = options[OPT_MAIN_FILE].AsBool();

		if (!isMainFile)
		{
			return ResourceSaver.Save(new InkStory() { IsMainFile = false }, destFile);
		}

		UpdateCache(sourceFile, ExtractIncludes(sourceFile));

		Error returnValue = ImportFromInk(sourceFile, destFile);

		var additionalFiles = GetCache().Where(kvp => kvp.Value.Contains(sourceFile)).Select(kvp => kvp.Key);

		foreach (var additionalFile in additionalFiles)
		{
			AppendImportExternalResource(additionalFile);
		}

		return returnValue;
	}

	public static void UpdateCache(string sourceFile, List<string> dependencies)
	{
		DependenciesCache cache = GetCache();
		cache[sourceFile] = [.. dependencies];
		cache = cache.Where(kvp => kvp.Value.Length > 0).ToDictionary(kvp => kvp.Key, kvp => kvp.Value);

		using var file = Godot.FileAccess.Open(CACHE_FILE, Godot.FileAccess.ModeFlags.Write);
		file?.StoreString(JsonSerializer.Serialize(cache));
	}

	public static DependenciesCache GetCache()
	{
		using var file = Godot.FileAccess.Open(CACHE_FILE, Godot.FileAccess.ModeFlags.Read);

		try
		{
			return JsonSerializer.Deserialize<DependenciesCache>(file?.GetAsText() ?? "{}")
				?? [];
		}

		catch (JsonException)
		{
			return [];
		}
	}


	//> Sub

	static Error ImportFromInk(string sourceFile, string destFile)
	{
		using var file = Godot.FileAccess.Open(sourceFile, Godot.FileAccess.ModeFlags.Read);
		if (file is null)
		{
			return Godot.FileAccess.GetOpenError();
		}

		Compiler compiler = new(file.GetAsText(), new Compiler.Options
		{
			sourceFilename = sourceFile,
			errorHandler = InkCompilerErrorHandler,
			fileHandler = new FileHandler(
				Path.GetDirectoryName(file.GetPathAbsolute()) ?? ProjectSettings.GlobalizePath("res://")
			),
		});

		try
		{
			string storyContent = compiler.Compile().ToJson();
			InkStory resource = new(storyContent);

			return ResourceSaver.Save(resource, destFile, ResourceSaver.SaverFlags.Compress);
		}

		catch (Exception)
		{
			return Error.CompilationFailed;
		}
	}

	static List<string> ExtractIncludes(string sourceFile)
	{
		using var file = Godot.FileAccess.Open(sourceFile, Godot.FileAccess.ModeFlags.Read);

		return [.. includeRegex.Matches(file.GetAsText())
						   .OfType<Match>()
						   .Select(match => sourceFile.GetBaseDir().PathJoin(match.Groups["Path"].Value.TrimEnd('\r')))];
	}

	static void InkCompilerErrorHandler(string message, ErrorType errorType)
	{
		switch (errorType)
		{
			case ErrorType.Warning:
				GD.PushWarning(message);
				break;

			case ErrorType.Error:
				GD.PushError(message);
				break;

			default:
				break;
		}
	}

	class FileHandler(string rootDir) : IFileHandler
	{
		public string ResolveInkFilename(string includeName)
		{
			return Path.Combine(rootDir, includeName);
		}

		public string LoadInkFileContents(string fullFilename)
		{
			return File.ReadAllText(fullFilename);
		}
	}


	//> RegEx
	static readonly Regex includeRegex = IncludeRegex();

	[GeneratedRegex(@"^\s*INCLUDE\s*(?<Path>.*)\s*$", RegexOptions.Multiline | RegexOptions.Compiled)]
	public static partial Regex IncludeRegex();
}

#endif
