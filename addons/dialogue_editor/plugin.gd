@tool
extends EditorPlugin

@export var editor_scene := preload("res://addons/dialogue_editor/editor/InkEditor.tscn")
@export var icon := preload("res://addons/dialogue_editor/icon.svg")

var dock_content

const dock_name := "InkEditor"

func _enter_tree():
	if dock_content: dock_content.queue_free()
	dock_content = editor_scene.instantiate()
	dock_content.hide()
	EditorInterface.get_editor_main_screen().add_child(dock_content)

func _exit_tree():
	EditorInterface.get_editor_main_screen().remove_child(dock_content)

#region Plugin Info
################################################################################

func _make_visible(visible:bool) -> void:
	if not dock_content:
		return
	
	if dock_content.get_parent() is Window:
		if visible:
			EditorInterface.set_main_screen_editor(dock_name)
			dock_content.show()
			dock_content.get_parent().grab_focus()
	else:
		dock_content.visible = visible

func _has_main_screen(): return true

func _get_plugin_name(): return dock_name

func _get_plugin_icon(): return icon

################################################################################
#endregion
