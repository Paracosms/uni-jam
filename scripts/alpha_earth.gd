extends TextureRect

var mapUI = get_parent()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			mapUI.alphaClickHandler()
			print("i am steve")
