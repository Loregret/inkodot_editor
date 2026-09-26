@tool
extends EditorPlugin

var _importer: EditorImportPlugin

func _enter_tree() -> void:
	var src_path : String = get_script().get_path().get_base_dir().path_join("ink_importer")
	var importer_script := load(src_path.path_join("InkStoryImporter.cs")) as CSharpScript

	if not importer_script.can_instantiate():
		printerr("Can't instantiate importer!")
		return

	_importer = importer_script.new() as EditorImportPlugin
	add_import_plugin(_importer)

func _exit_tree() -> void:
	if not _importer: return
	remove_import_plugin(_importer)
	_importer = null

func _notification(what : int) -> void:
	if what == NOTIFICATION_POST_ENTER_TREE:
		if _importer: return
		get_editor_interface().set_plugin_enabled("godot_ink", false)
		printerr("godot_ink could not be loaded.")
