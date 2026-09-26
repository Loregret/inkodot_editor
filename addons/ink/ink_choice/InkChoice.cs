using Godot;
using System.Collections.Generic;

namespace GodotInkle;

[Tool, GlobalClass]
public partial class InkChoice : RefCounted
{
	public string Text => inner.text;
	public int Index => inner.index;

	public string PathStringOnChoice => inner.pathStringOnChoice;
	public string SourcePath => inner.sourcePath;

	public IReadOnlyList<string> Tags => inner.tags ?? (IReadOnlyList<string>)[];

	readonly Ink.Runtime.Choice inner;

	InkChoice()
	{
		inner = new Ink.Runtime.Choice();
	}

	public InkChoice(Ink.Runtime.Choice inner)
	{
		this.inner = inner;
	}

	public override string ToString() => $"{Index}: {Text}";
}
