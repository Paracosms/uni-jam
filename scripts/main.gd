extends Node2D

@export var asteroid_scene: PackedScene


var spawn_timer := Timer.new()

func _ready():
	randomize() # Create random seed i think?
	spawn_timer.wait_time = 1  # Delay, i tried to make it an exported variable but it didnt work :(
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "spawn_asteroid")) # I think this makes it run when the time is up
	add_child(spawn_timer)
	spawn_timer.start()
	
func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	
	# Generate random position
	asteroid.global_position = Vector2(randf_range(0,1920), randf_range(0,1080)) # tbh i have no idea what vector2 means
	
	# Thank you stack overflow for whatever this means
	var earth_node = get_node("Earth")
	asteroid.earth = earth_node
	
	add_child(asteroid)
