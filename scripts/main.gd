extends Node2D

@export var asteroid_scene: PackedScene

@onready var shop_scene = preload("res://scenes/shop.tscn")
@onready var alpha_scene = preload("res://scenes/earth.tscn")
@onready var beta_scene = preload("res://scenes/beta.tscn")
@onready var gamma_scene = preload("res://scenes/gamma.tscn")
@onready var delta_scene = preload("res://scenes/delta.tscn")




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
	call_deferred("trulyReady") # Executes when everything has loaded in
	
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

func _process(_delta):
	### STAR CENTERING LOGIC ###
	get_tree().call_group("earth", "set_global_position", Globals.centerScreen)

# This function executes after ALL nodes in every scene has loaded in
func trulyReady():
	### MAP SELECTION LOGIC ###
	var mapUI = $"UIResizer/UIRenderer/UI/windowScale/Info/bottomRight/VBoxContainer/mapUI"
	mapUI.connect("alphaClicked", switchToAlpha)
	mapUI.connect("betaClicked", switchToBeta)
	mapUI.connect("gammaClicked", switchToGamma)
	mapUI.connect("deltaClicked", switchToDelta)
	
	### SHOP SCREEN LOGIC ###
	$UIResizer/UIRenderer/UI/windowScale/Info/bottomLeft/toggleShop.connect("shopToggled", toggleShop)
	var screen_size = get_viewport().get_visible_rect().size
	var shop = shop_scene.instantiate()
	add_child(shop)
	get_node("Shop").position = Vector2(screen_size.x / 2, 0)
	get_node("Shop").visible = false

func spawn_asteroid(type : String = "base"):
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
	
	# Speed of Asteroid based on size
	
	var weight = (2 - result) / (1.9 - 0.1)
	var base_speed = lerp(50.0, 300.0, weight) # y = a + x*(b-a) https://www.desmos.com/calculator/4xo9bmhyq1
	
	# Health Variable
	var base_health = round(lerp(1.0, 2.0, result))
	
	### ASTEROID TYPE LOGIC ###
	var asteroidRandomizer = 0
	
	# TODO: change sprite depending on the type of asteroid
	match Globals.currentStar:
		3: asteroidRandomizer = randi() % 3
		2: asteroidRandomizer = randi() % 2
		1: asteroidRandomizer = randi() % 1
		# 0 should do nothing as it is the base asteroid, so this case is not included
	
	match asteroidRandomizer:
		2: 
			result = clamp(result, 0.4, 1.0)
		1:
			base_speed += 50
			# change sprite here
		0: 
			base_health += 2
			# change sprite here
	
	if type == "speed" && asteroidRandomizer != 1:
		base_speed += 50
	
	### SET ASTEROID PROPERTIES ###
	
	var variation = base_speed * 0.1
	var speed = randf_range(base_speed - variation, base_speed + variation)
	
	asteroid.speed = speed
	
	# Sets the scale
	asteroid.scale = Vector2.ONE * result
	
	# Scale of Asteroid based on difficulty and size (Bigger = more health)
	asteroid.health = base_health
	
	### END SPAWN LOGIC ###
	
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

# All switchTo functions changes stars and respawns all removed asteroids with +50 base speed
# Alpha is bottom (earth)
func switchToAlpha():
	var alpha = alpha_scene.instantiate()
	var asteroidsToSpawn : int = 0
	for star in get_tree().get_nodes_in_group("earth"):
		star.queue_free()
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		asteroid.queue_free()
		if asteroidsToSpawn < 5:
			asteroidsToSpawn += 1
	for newAsteroid in asteroidsToSpawn:
		spawn_asteroid("speed")
	add_child(alpha)
	Globals.currentStar = 0

# Beta is left
func switchToBeta():
	var beta = beta_scene.instantiate()
	var asteroidsToSpawn : int = 0
	for star in get_tree().get_nodes_in_group("earth"):
		star.queue_free()
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		asteroid.queue_free()
		if asteroidsToSpawn < 5:
			asteroidsToSpawn += 1
	for newAsteroid in asteroidsToSpawn:
		spawn_asteroid("speed")
	add_child(beta)
	Globals.currentStar = 1

# Gamma is top
func switchToGamma():
	var gamma = gamma_scene.instantiate()
	var asteroidsToSpawn : int = 0
	for star in get_tree().get_nodes_in_group("earth"):
		star.queue_free()
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		asteroid.queue_free()
		if asteroidsToSpawn < 5:
			asteroidsToSpawn += 1
	for newAsteroid in asteroidsToSpawn:
		spawn_asteroid("speed")
	add_child(gamma)
	Globals.currentStar = 2

# Delta is right
func switchToDelta():
	var delta = delta_scene.instantiate()
	var asteroidsToSpawn : int = 0
	for star in get_tree().get_nodes_in_group("earth"):
		star.queue_free()
	for asteroid in get_tree().get_nodes_in_group("asteroid"):
		asteroid.queue_free()
		if asteroidsToSpawn < 5:
			asteroidsToSpawn += 1
	for newAsteroid in asteroidsToSpawn:
		spawn_asteroid("speed")
	add_child(delta)
	Globals.currentStar = 3
