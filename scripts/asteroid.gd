extends CharacterBody2D

@onready var asteroidHealthTexture = preload("res://assets/sprites/asteroids/asteroidHealth.png")
@onready var asteroidSpeedTexture = preload("res://assets/sprites/asteroids/asteroidSpeed.png")
@onready var asteroidSmallTexture = preload("res://assets/sprites/asteroids/asteroidSmall.png")

@export var speed : float = 350.0
@export var health : int = 1
@export var type : String = "base"
var chipParticles = preload("res://scenes/asteroid_chip_particles.tscn")
var centerPosition : Vector2 = Vector2(960, 540)

signal asteroidChipped
signal asteroidExploded




func _physics_process(delta):
	rotation += 0.01
	
	# Variables
	var direction = (centerPosition - global_position).normalized()
	var movement = direction * speed * delta
	
	# Collision logic
	# This might be made more efficient idk
	var collision = move_and_collide(movement)
	if collision and collision.get_collider().is_in_group("earth"): # Earth -> StaticBody2D is now in "earth" group
		#print("Hit Earth") # Debug, remove later if you want andrew
		Globals.lives -= 1
		emit_signal("asteroidExploded")
		queue_free() # Destroys object
		
func _process(_delta):
	# Kill asteroids if they are dead # wow that sounds stupid
	if health <= 0:
		
		# Signal to play the explosion sound is emitted and sent to the main.gd because this asteroid is about to kill itself
		emit_signal("asteroidExploded")
		
		### STARPOINTS AWARDED LOGIC ###
		var critMult : int = 1 # Critical Multiplier 
		if randf() <= Globals.critical_hit: # 25% or 50% chance
			critMult = 2 # Double starpoints
		
		var extraStarpoints = abs(health) * Globals.overkill # Overkill ability
		Globals.starPoints += (Globals.baseYield + extraStarpoints) * critMult # Starpoints Formula
		
		queue_free() # Kill the asteroid
		
		Globals.currentKills += 1 # Kill count
		if Globals.currentKills >= Globals.lifeSteal: # LifeSteal logic
			Globals.currentKills = 0
			Globals.lives += 1


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if scale.x <= Globals.crushSmall: # Crush small asteroid logic
			health = 0
		
		health -= Globals.clickDamage
		var newParticles = chipParticles.instantiate()
		
		match type:
			"small": newParticles.texture = asteroidSmallTexture
			"speed": newParticles.texture = asteroidSpeedTexture
			"health": newParticles.texture = asteroidHealthTexture
		
		add_child(newParticles)
		newParticles.emitting = true
		emit_signal("asteroidChipped")
		
		# Kill particles when done (I doubt this saves much performance but ah well)
		await get_tree().create_timer(newParticles.lifetime).timeout
		newParticles.queue_free()
		
		print("Health is now " + str(health) + ", you did " + str(Globals.clickDamage) + " damage")
