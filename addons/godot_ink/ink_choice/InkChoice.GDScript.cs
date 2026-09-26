#pragma warning disable IDE0022
#pragma warning disable IDE1006

using System.ComponentModel;
using GC = Godot.Collections;

namespace GodotInkle;

public partial class InkChoice
{
	[EditorBrowsable(EditorBrowsableState.Never)]
	public string get_text() => Text;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public string get_path_string_on_choice() => PathStringOnChoice;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public string get_source_path() => SourcePath;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public int get_index() => Index;

	[EditorBrowsable(EditorBrowsableState.Never)]
	public GC.Array<string> get_tags() => [.. Tags];
}
