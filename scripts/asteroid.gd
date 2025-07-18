extends CharacterBody2D

func _process(delta):
	velocity = get_local_mouse_position()
	move_and_slide()
