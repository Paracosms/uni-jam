extends TextureButton

signal skillsUpToggled

func _on_mouse_pressed():
	emit_signal("skillsUpToggled")
