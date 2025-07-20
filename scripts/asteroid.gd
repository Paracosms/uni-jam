extends CharacterBody2D


@export var speed : float = 350.0
@export var health : int = 1
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
		var critActive : int = 0 #
		if Globals.critEnabled && (randi() % 4) == 0: # Critical hit procs if a random integer between 0 - 3 is equal to 0 (aka 1 in 4 chance)
			critActive = 1
			#print("Critical hit!")
		Globals.starPoints += Globals.baseYield + (Globals.baseYield * Globals.critMultiplier * critActive)
		critActive = 0 # Prepares for next click
		queue_free()


func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		health -= Globals.clickDamage
		var newParticles = chipParticles.instantiate()
		add_child(newParticles)
		newParticles.emitting = true
		emit_signal("asteroidChipped")
		
		# Kill particles when done (I doubt this saves much performance but ah well)
		await get_tree().create_timer(newParticles.lifetime).timeout
		newParticles.queue_free()
		
		print("Health is now " + str(health) + ", you did " + str(Globals.clickDamage) + " damage")
