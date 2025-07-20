extends TextureButton

signal skillsToggled

func _on_mouse_entered():
	emit_signal("skillsToggled")
