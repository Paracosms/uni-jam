extends Node2D

@onready var binocularsCamera = $BinocularsCamera
@onready var earthNode = $"/root/Main/Earth"

var camera_speed = 50.0 # Speed 
var camera_max_offset = 100.0
var deadzone_size = 250.0

func _process(delta): # This took me like 2 hours so ignore it if it makes no sense because it works (kinda)
	# print(str(binocularsCamera.position)) # Debug 
	if Globals.binocularsEnabled:
		
		var screen_size = get_viewport().get_visible_rect().size
		var screen_center = screen_size / 2
		
		var mouse_position = get_global_mouse_position()
		var mouse_offset = mouse_position - screen_center
		var camera_target_position : Vector2
		
		if Globals.shopOpened == true or mouse_offset.length() < deadzone_size:
				camera_target_position = screen_center
				binocularsCamera.global_position = binocularsCamera.global_position.move_toward(
					camera_target_position, camera_speed * delta
				)
		else:
			if mouse_offset.length() > camera_max_offset:
				mouse_offset = mouse_offset.normalized() * camera_max_offset
				
			camera_target_position = screen_center + mouse_offset
			binocularsCamera.global_position = binocularsCamera.global_position.move_toward(
				camera_target_position, camera_speed * delta
			)
		
	
	
