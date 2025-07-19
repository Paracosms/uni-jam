extends Node2D

@export var asteroid_scene: PackedScene
@onready var shop_scene = preload("res://scenes/shop.tscn")


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

var spawn_timer := Timer.new()

var meteorShower_timer := Timer.new()

func get_offscreen_position() -> Vector2: # I still dont know what a vector2 is
	var screen_size = get_viewport().get_visible_rect().size
	var edge = randi() % 4  # 0=top,1=right,2=bottom,3=left
	var pos = Vector2.ZERO

	match edge:
		0:  # top edge
			pos.x = randf_range(0, screen_size.x)
			pos.y = -150  # 100 pixels above top
		1:  # right edge
			pos.x = screen_size.x + 150 # 100px to the right
			pos.y = randf_range(0, screen_size.y)
		2:  # bottom edge
			pos.x = randf_range(0, screen_size.x)
			pos.y = screen_size.y + 150 # 100px below
		3:  # left edge
			pos.x = -150 # 100px to left
			pos.y = randf_range(0, screen_size.y)
	return pos # returns (x,y)


func _ready():
	randomize() # Create random seed i think?
	
	### MAP SELECTION LOGIC ###
	var mapUI = $"UI Controller/UI/bottomRight/VBoxContainer/mapUI"
	mapUI.connect("alphaClicked", switchToAlpha)
	mapUI.connect("betaClicked", switchToBeta)
	mapUI.connect("gammaClicked", switchToGamma)
	mapUI.connect("deltaClicked", switchToDelta)
	
	
	
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
	$"UI Controller/UI/bottomLeft/toggleShop".connect("shopToggled", toggleShop)
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
	
	# Scale of Asteroid based on dificulty
	var base = randf_range(-1.0, 1.0) # Base random value
	
	# Gets exponent based on difficulty
	# When exponent is higher, extreme values are rare
	# Opposite for low exponent
	var exponent = 1.0 + (1.0 - difficulty) * 1.0
	var shaped_value = sign(base) * pow(abs(base), exponent)
	shaped_value = clamp(shaped_value, -0.8, 0.8) # Prevents far extremes hopefully
	
	# Allows for the full range but biases towards the specified areas
	var spread = 0.5 + difficulty * 0.4 # Lower numbers = more spread
	var result = clamp((1.0 + shaped_value * spread), 0.4, 1.9) # Last two numbers are min and max
	
	# Sets the scale
	asteroid.scale = Vector2.ONE * result
	
	# Speed of Asteroid based on size
	
	var weight = (2 - result) / (1.9 - 0.1)
	var base_speed = lerp(50.0, 300.0, weight) # y = a + x*(b-a) https://www.desmos.com/calculator/4xo9bmhyq1
	
	var variation = base_speed * 0.1
	var speed = randf_range(base_speed - variation, base_speed + variation)
	
	asteroid.speed = speed
	
	# Scale of Asteroid based on difficulty and size (Bigger = more health)
	var base_health = round(lerp(1.0, 2.0, result))
	asteroid.health = base_health
	
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
		difficulty = 0.05
		for n in range(7): # n = number of asteroids but not actually idk why
			spawn_asteroid()
			await get_tree().create_timer(0.2).timeout # Wait for 0.2 seconds
		difficulty = old
		spawn_timer.paused = false
		meteorShower_timer.paused = false
	else:
		print("\nMeteor Failed\n")

func playChipSound():
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

func toggleShop():
	# Toggles the shop
	if Globals.shopOpened:
		get_node("Shop").visible = false
		Globals.shopOpened = false
	else:
		get_node("Shop").visible = true
    Globals.shopOpened = true

# Alpha is bottom (earth)
func switchToAlpha():
	print("alpha")

# Beta is left
func switchToBeta():
	print("beta")

# Gamma is top
func switchToGamma():
	print("gamma")

# Delta is right
func switchToDelta():
	print("delta")
  
