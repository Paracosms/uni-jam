extends Node2D

@export var asteroid_scene: PackedScene
@onready var shop_scene = preload("res://scenes/shop.tscn")

var shopOpened : bool = false
var chipAudio = [
	preload("res://assets/audio/Chip0.wav"),
	preload("res://assets/audio/Chip1.wav"),
	preload("res://assets/audio/Chip2.wav"),
	preload("res://assets/audio/Chip3.wav")]
var explosionAudio = [
	preload("res://assets/audio/Explosion0.wav"),
	preload("res://assets/audio/Explosion1.wav"),
	preload("res://assets/audio/Explosion2.wav"),
	preload("res://assets/audio/Explosion3.wav")]



# Core Difficulty (0 - Easy, 1 - Hard)
@export var difficulty = 0.5
var scaled_difficulty = pow(difficulty, 1) # I feel like the 0-1 was too easy

var spawn_timer := Timer.new()

var meteorShower_timer := Timer.new()

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
	
	### CONSTANT METEOR SPAWNING LOGIC ###
	spawn_timer.wait_time = 1  # Delay, i tried to make it an exported variable but it didnt work :(
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "spawn_asteroid")) # I think this makes it run when the time is up
	add_child(spawn_timer)
	spawn_timer.start()
	
	### OCCASIONAL METEOR SHOWER LOGIC ###
	
	meteorShower_timer.wait_time = 10
	meteorShower_timer.one_shot = false
	meteorShower_timer.connect("timeout", Callable(self, "tryMeteorShower"))
	add_child(meteorShower_timer)
	meteorShower_timer.start()
	
	
	### SHOP SCREEN LOGIC ###
	var screen_size = get_viewport().get_visible_rect().size
	var shop = shop_scene.instantiate()
	add_child(shop)
	get_node("Shop").position = Vector2(screen_size.x / 2, 0)
	get_node("Shop").visible = false
	

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	
	# Asteroid spawning location
	asteroid.global_position = get_offscreen_position() # Location off-screen
	
	### ASTEROID BALANCING BASED ON DIFFICULTY ###
	
	# Scale of Asteroid based on difficulty
	var scale_min = 0.7 - scaled_difficulty * 0.3
	var scale_max = 1.2 - scaled_difficulty * 0.2
	asteroid.scale = Vector2.ONE * randf_range(scale_min, scale_max)
	
	# Scale of Asteroid based on difficulty
	var speed_min = 100 + scaled_difficulty * 50
	var speed_max = 250 + scaled_difficulty * 250
	asteroid.speed = randf_range(speed_min, speed_max)
	
	# Scale of Asteroid based on difficulty and size (Bigger = more health)
	var size_factor = asteroid.scale.x
	var base_health = lerp(1.0, 7.0, scaled_difficulty)
	asteroid.health = clamp(round(base_health * size_factor), 1, 5)
	
	### END SPAWN LOGIC ###
	
	# Thank you stack overflow for whatever this means
	var earth_node = get_node("Earth")
	asteroid.earth = earth_node
	
	asteroid.connect("asteroidChipped", playChipSound)
	asteroid.connect("asteroidExploded", playExplosionSound)
	
	add_child(asteroid)
	print("Asteroid spawned with " + str(snapped(asteroid.scale.x, 0.01)) + " scale, " 
									+ str(round(asteroid.speed)) + " speed, and "
									+ str(asteroid.health) + " health at difficulty: " + str(snapped(difficulty, 0.01)))

func tryMeteorShower():
	# Multiply this number by 10 to get expected number of seconds inbetween meteor shower
	var chance = randi() % 6
	
	if chance == 1:
		print("\n\nMeteor Shower!\n\n")
		spawn_timer.paused = true
		meteorShower_timer.paused = true
		var old = difficulty
		difficulty = 0.1
		for n in range(11): # n = number of asteroids minus 1
			spawn_asteroid()
			await get_tree().create_timer(0.2).timeout # Wait for 0.2 seconds
		difficulty = old
		spawn_timer.paused = false
		meteorShower_timer.paused = false
	else:
		print("\nMeteor Failed\n")

func playChipSound():
	print("chip")
	var soundPlayer = AudioStreamPlayer.new()
	soundPlayer.stream = chipAudio.pick_random()
	soundPlayer.volume_db = Globals.volume
	add_child(soundPlayer)
	soundPlayer.play()
	soundPlayer.finished.connect(soundPlayer.queue_free)

func playExplosionSound():
	var soundPlayer = AudioStreamPlayer.new()
	soundPlayer.stream = explosionAudio.pick_random()
	soundPlayer.volume_db = Globals.volume
	add_child(soundPlayer)
	soundPlayer.play()
	soundPlayer.finished.connect(soundPlayer.queue_free)

func _on_toggle_shop_pressed():
	# Toggles the shop
	if shopOpened:
		get_node("Shop").visible = false
		shopOpened = false
	else:
		get_node("Shop").visible = true
		shopOpened = true
