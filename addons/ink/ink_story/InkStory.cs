using InkodotEditor;
using Godot;
using System;
using System.Collections.Generic;

using static GodotInkle.MarshalUtils;
using PropertyList = Godot.Collections.Array<Godot.Collections.Dictionary>;

namespace GodotInkle;

[Tool, GlobalClass, Icon("uid://op2d8aagi35f")]
public sealed partial class InkStory : Resource
{
	public bool IsMainFile = true;
	public bool IsInitialized;

	public Ink.Runtime.Story? RuntimeStory;

	public string RawStory = "";

	public string CurrentText => RuntimeStory?.currentText ?? throw new NullReferenceException();
	public string CurrentFlowName => RuntimeStory?.currentFlowName ?? throw new NullReferenceException();

	public IReadOnlyList<InkChoice> CurrentChoices => ToVariants(RuntimeStory?.currentChoices ?? throw new NullReferenceException());

	public IReadOnlyList<string> GlobalTags => RuntimeStory?.globalTags ?? throw new NullReferenceException();
	public IReadOnlyList<string> CurrentTags => RuntimeStory?.currentTags ?? throw new NullReferenceException();
	public IReadOnlyList<string> CurrentWarnings => RuntimeStory?.currentWarnings ?? throw new NullReferenceException();
	public IReadOnlyList<string> CurrentErrors => RuntimeStory?.currentErrors ?? throw new NullReferenceException();
	public IReadOnlyList<string> AliveFlowNames => RuntimeStory?.aliveFlowNames ?? throw new NullReferenceException();

	public bool HasWarning => RuntimeStory?.hasWarning ?? throw new NullReferenceException();
	public bool HasError => RuntimeStory?.hasError ?? throw new NullReferenceException();
	public bool CanContinue => RuntimeStory?.canContinue ?? throw new NullReferenceException();
	public bool CurrentFlowIsDefaultFlow => RuntimeStory?.currentFlowIsDefaultFlow ?? throw new NullReferenceException();

	[Signal] public delegate void ContinuedEventHandler();
	[Signal] public delegate void MadeChoiceEventHandler(InkChoice choice);


	//> Constructor

	public InkStory() { }

	public InkStory(string json)
	{
		RawStory = json;
	}


	//> Main

	/// <summary>
	/// Initialize Ink Runtime before using any function.
	/// </summary>
	public void Initialize()
	{
		if (IsInitialized) return;
		IsInitialized = true;

		if (RawStory.IsNullOrEmpty()) return;

		if (!IsMainFile)
		{
			GD.PushError($"{this} is not a main_file! Please import it with 'is_main_file' set to true.");
			return;
		}

		if (RuntimeStory is not null)
		{
			RuntimeStory.onDidContinue -= OnContinued;
			RuntimeStory.onMakeChoice -= OnMadeChoice;
		}

		RuntimeStory = new Ink.Runtime.Story(RawStory);

		RuntimeStory.onDidContinue += OnContinued;
		RuntimeStory.onMakeChoice += OnMadeChoice;
	}

	/// <summary>
	/// Continue the story for one line of content, if possible.
	/// If you're not sure if there's more content available, for example if you
	/// want to check whether you're at a choice point or at the end of the story,
	/// you should call <c>canContinue</c> before calling this function.
	/// </summary>
	/// <returns>The line of text content.</returns>
	public string Continue()
	{
		try
		{
			return RuntimeStory?.Continue() ?? "";
		}

		catch
		{
			return "";
		}
	}

	/// <summary>
	/// Continue the story until the next choice point or until it runs out of content.
	/// This is as opposed to the Continue() method which only evaluates one line of
	/// output at a time.
	/// </summary>
	/// <returns>The resulting text evaluated by the ink engine, concatenated together.</returns>
	public string ContinueMaximally()
	{
		try
		{
			return RuntimeStory?.ContinueMaximally() ?? "";
		}

		catch
		{
			return "";
		}
	}

	/// <summary>
	/// Chooses the Choice from the currentChoices list with the given
	/// index. Internally, this sets the current content path to that
	/// pointed to by the Choice, ready to continue story evaluation.
	/// </summary>
	/// <param name="choiceIdx">The index of the choice to choose.</param>
	public void ChooseChoiceIndex(int choiceIdx)
	{
		RuntimeStory?.ChooseChoiceIndex(choiceIdx);
	}

	/// <summary>
	/// Chooses the Choice from the currentChoices list with the given path.
	/// </summary>
	public void ChoosePathString(string path, bool resetCallstack = true, params Variant[] arguments)
	{
		RuntimeStory?.ChoosePathString(path, resetCallstack, FromVariants(arguments));
	}

	/// <summary>
	/// Unwinds the callstack. Useful to reset the Story's evaluation
	/// without actually changing any meaningful state, for example if
	/// you want to exit a section of story prematurely and tell it to
	/// go elsewhere with a call to ChoosePathString(...).
	/// Doing so without calling ResetCallstack() could cause unexpected
	/// issues if, for example, the Story was in a tunnel already.
	/// </summary>
	public void ResetCallstack()
	{
		RuntimeStory?.ResetCallstack();
	}

	/// <summary>
	/// Reset the Story back to its initial state as it was when it was
	/// first constructed.
	/// </summary>
	public void ResetRuntimeState()
	{
		RuntimeStory?.ResetState();
	}

	/// <summary>
	/// Gets any tags associated with a particular knot or knot.stitch.
	/// These are defined as hash tags defined at the very top of a knot or stitch.
	/// </summary>
	/// <param name="path">The path of the knot or stitch, in the form "knot" or "knot.stitch".</param>
	/// <returns>The list of tags.</returns>
	public IReadOnlyList<string> TagsForContentAtPath(string path)
	{
		return RuntimeStory?.TagsForContentAtPath(path) ?? [];
	}

	/// <summary>
	///
	/// </summary>
	/// <param name="flowName"></param>
	public void RemoveFlow(string flowName)
	{
		RuntimeStory?.RemoveFlow(flowName);
	}

	/// <summary>
	///
	/// </summary>
	/// <param name="flowName"></param>
	public void SwitchFlow(string flowName)
	{
		RuntimeStory?.SwitchFlow(flowName);
	}

	/// <summary>
	///
	/// </summary>
	public void SwitchToDefaultFlow()
	{
		RuntimeStory?.SwitchToDefaultFlow();
	}

	/// <summary>
	///
	/// </summary>
	public int VisitCountAtPathString(string pathString)
	{
		return RuntimeStory?.state.VisitCountAtPathString(pathString) ?? default;
	}

	/// <summary>
	///
	/// </summary>
	/// <param name="message"></param>
	public void Error(string message)
	{
		RuntimeStory?.Error(message);
	}

	/// <summary>
	///
	/// </summary>
	/// <param name="message"></param>
	/// <param name="useEndLineNumber"></param>
	public void Error(string message, bool useEndLineNumber)
	{
		RuntimeStory?.Error(message, useEndLineNumber);
	}

	/// <summary>
	///
	/// </summary>
	/// <param name="message"></param>
	public void Warning(string message)
	{
		RuntimeStory?.Warning(message);
	}

	/// <summary>
	/// Save the current story state a JSON string.
	/// </summary>
	/// <returns>The current state serialized into a JSON string.</returns>
	public string SaveState()
	{
		return RuntimeStory?.state.ToJson() ?? "";
	}

	/// <summary>
	/// Save the current story state to a JSON file.
	/// </summary>
	/// <param name="filePath">The path to the file we will be writing to.</param>
	public void SaveStateFile(string filePath)
	{
		using FileAccess file = FileAccess.Open(filePath, FileAccess.ModeFlags.Write);
		file.StoreString(SaveState());
	}

	/// <summary>
	/// Load a JSON string as the current story state.
	/// </summary>
	/// <param name="jsonState">The JSON string to load.</param>
	public void LoadState(string jsonState)
	{
		RuntimeStory?.state.LoadJson(jsonState);
	}

	/// <summary>
	/// Load the content of a JSON file as the current story state.
	/// </summary>
	/// <param name="filePath">The path to the file we will be reading from.</param>
	public void LoadStateFile(string filePath)
	{
		using FileAccess file = FileAccess.Open(filePath, FileAccess.ModeFlags.Read);
		LoadState(file.GetAsText());
	}


	//> Misc

	void OnContinued()
	{
		EmitSignal(SignalName.Continued);
	}

	void OnMadeChoice(Ink.Runtime.Choice choice)
	{
		EmitSignal(SignalName.MadeChoice, new InkChoice(choice));
	}

	public override PropertyList _GetPropertyList()
	{
		PropertyList properties = base._GetPropertyList() ?? [];

		properties.Add(new Godot.Collections.Dictionary()
		{
			{ "name", PropertyName.RawStory },
			{ "type", Variant.From(Variant.Type.Object) },
			{ "usage", Variant.From(PropertyUsageFlags.NoEditor) },
		});

		return properties;
	}
}
