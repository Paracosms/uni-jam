extends Node2D

# Breaking asteroids yields 2 star points. [30 Starpoints]
func _on_double_yield_pressed():
	var price = 30
	if Globals.starPoints >= price:
		Globals.starPoints -= price
		Globals.baseYield = 2
		%doubleYield.disabled = true

# Your clicks break asteroids twice as fast. [30 Starpoints]
func _on_double_damage_pressed():
	var price = 30
	if Globals.starPoints >= price:
		Globals.starPoints -= price
		Globals.clickDamage = 2
		%doubleDamage.disabled = true

# Your clicks have a 1 in 4 chance to yield double the starpoints. [100 Starpoints]
func _on_enable_crit_pressed():
	var price = 100
	if Globals.starPoints >= price:
		Globals.starPoints -= price
		Globals.critEnabled = true
		%enableCrit.disabled = true
