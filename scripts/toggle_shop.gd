extends Button

signal shopToggled

func _on_pressed():
	emit_signal("shopToggled")
