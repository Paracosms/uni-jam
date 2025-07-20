extends TextureButton

signal shopToggled

func _on_mouse_entered():
	emit_signal("shopToggled")
	print ("should be working")

#func _on_hover():
	
