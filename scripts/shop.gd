extends Node2D

var starPoints = Globals.starPoints

func _process(delta):
	print(starPoints)

# Breaking asteroids yields 2 star points. [50 Starpoints]
func _on_double_yield_pressed():
	if starPoints >= 50:
		Globals.starPoints -= 50
		Globals.yieldMultiplier = 2
		print("purchased !")

# Your clicks break asteroids twice as fast. [50 Starpoints]
func _on_double_damage_pressed():
	if starPoints >= 50:
		Globals.starPoints -= 50
		Globals.clickDamage = 2
		print("purchased !")
