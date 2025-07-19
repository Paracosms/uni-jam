extends TextureRect

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			get_parent().alphaClickHandler()
