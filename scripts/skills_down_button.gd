extends TextureButton

signal skillsDownToggled

func _on_mouse_pressed():
	emit_signal("skillsDownToggled")
