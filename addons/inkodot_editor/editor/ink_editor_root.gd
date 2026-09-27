@tool
extends PanelContainer

func _shortcut_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return

	if event.ctrl_pressed and event.keycode == KEY_F:
		%SearchPopup.open_with_focus()
		get_viewport().set_input_as_handled()
