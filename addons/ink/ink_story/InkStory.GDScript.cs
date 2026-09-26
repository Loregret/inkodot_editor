#pragma warning disable IDE0022
#pragma warning disable IDE1006

using Godot;
using System;
using System.ComponentModel;

using GC = Godot.Collections;

namespace GodotInkle;

public partial class InkStory
{
	[EditorBrowsable(EditorBrowsableState.Never)]
	public string continue_story()
	{
		try
		{
			return Continue();
		}

		catch
		{
			return "";
		}
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void initialize()
	{
		Initialize();
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public bool can_continue() => CanContinue;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public GC.Array<InkChoice> get_current_choices() => [.. CurrentChoices];

	[EditorBrowsable(EditorBrowsableState.Never)]
	public GC.Array<string> get_current_tags() => [.. CurrentTags];

	[EditorBrowsable(EditorBrowsableState.Never)]
	public string get_current_text() => CurrentText;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void reset_runtime_state() => ResetRuntimeState();

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void choose_choice_index(int index)
	{
		ChooseChoiceIndex(index);
	}


	//> Choose Path

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void choose_path_string(string path)
	{
		ChoosePathString(path, true, []);
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void choose_path_string(string path, bool resetCallstack)
	{
		ChoosePathString(path, resetCallstack, []);
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void choose_path_string(string path, GC.Array arguments)
	{
		ChoosePathString(path, true, [.. arguments]);
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void choose_path_string(string path, bool resetCallstack, GC.Array arguments)
	{
		ChoosePathString(path, resetCallstack, [.. arguments]);
	}


	//> Functions

	/// <summary>
	/// Evaluates a function defined in ink.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <returns>
	/// The return value as returned from the ink function with `~ return myValue`, or a nil
	/// variant if nothing is returned.
	/// </returns>
	[EditorBrowsable(EditorBrowsableState.Never)]
	public Variant evaluate_function(string functionName)
	{
		return EvaluateFunction(functionName, System.Array.Empty<Variant>());
	}

	/// <summary>
	/// Evaluates a function defined in ink with arguments.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <param name="arguments">The arguments the ink function takes, if any.</param>
	/// <returns>
	/// The return value as returned from the ink function with `~ return myValue`, or a nil
	/// variant if nothing is returned.
	/// </returns>
	[EditorBrowsable(EditorBrowsableState.Never)]
	public Variant evaluate_function(string functionName, GC.Array arguments)
	{
		return EvaluateFunction(functionName, arguments);
	}

	[EditorBrowsable(EditorBrowsableState.Never)]
	public void bind_external_function(string funcName, Callable callable)
	{
		BindExternalFunction(funcName, callable, false);
	}
}