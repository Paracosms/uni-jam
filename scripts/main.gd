extends Node2D

@export var asteroid_scene: PackedScene


var spawn_timer := Timer.new()

func get_offscreen_position() -> Vector2: # I still dont know what a vector2 is
	var screen_size = get_viewport().get_visible_rect().size
	var edge = randi() % 4  # 0=top,1=right,2=bottom,3=left
	var pos = Vector2.ZERO

	match edge:
		0:  # top edge
			pos.x = randf_range(0, screen_size.x)
			pos.y = -100  # 100 pixels above top
		1:  # right edge
			pos.x = screen_size.x + 100 # 100px to the right
			pos.y = randf_range(0, screen_size.y)
		2:  # bottom edge
			pos.x = randf_range(0, screen_size.x)
			pos.y = screen_size.y + 100 # 100px below
		3:  # left edge
			pos.x = -100 # 100px to left
			pos.y = randf_range(0, screen_size.y)
	return pos # returns (x,y)


func _ready():
	randomize() # Create random seed i think?
	spawn_timer.wait_time = 1  # Delay, i tried to make it an exported variable but it didnt work :(
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "spawn_asteroid")) # I think this makes it run when the time is up
	add_child(spawn_timer)
	spawn_timer.start()
	
func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	
	# Asteroid spawning logic
	asteroid.global_position = get_offscreen_position() # Location off-screen
	asteroid.speed = randf_range(100,500) # Random speed
	
	# Thank you stack overflow for whatever this means
	var earth_node = get_node("Earth")
	asteroid.earth = earth_node
	
	add_child(asteroid)
