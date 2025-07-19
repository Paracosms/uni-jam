extends CharacterBody2D


@export var speed: float = 350.0
var earth: Node2D = null

func _physics_process(delta):
	if not earth:
		return
	
	# Variables
	var direction = (earth.global_position - global_position).normalized()
	var movement = direction * speed * delta
	
	# Collision logic
	# This might be made more efficient idk
	var collision = move_and_collide(movement)
	if collision and collision.get_collider().is_in_group("earth"): # Earth -> StaticBody2D is now in "earth" group
		print("Hit Earth") # Debug, remove later if you want andrew
		get_node("/root/Main/Globals").lives -= 1
		queue_free() # Destroys object

func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Asteroid clicked!")
		get_node("/root/Main/Globals").starPoints += 1
		queue_free()
