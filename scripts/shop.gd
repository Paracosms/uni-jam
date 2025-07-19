extends Node2D

var upgrades = {
	"crush_small": {
		"price": 25,
		"title": "Crush Small Asteroids",
		"description": "Instantly destroys the smallest asteroid with one click.",
		"effect": func():
	Globals.crushSmall = true
	},

	"double_yield": {
		"price": 40,
		"title": "Double Starpoint Yield",
		"description": "Breaking asteroids yields 2 starpoints instead of 1.",
		"effect": func():
	Globals.baseYield = 2
	},

	"double_damage": {
		"price": 60,
		"title": "Double Click Damage",
		"description": "Your clicks deal twice the damage to asteroids.",
		"effect": func():
	Globals.clickDamage = 2
	},

	"slow_asteroids": {
		"price": 75,
		"title": "Slow Falling Asteroids",
		"description": "Asteroids fall 10% slower",
		"effect": func():
	Globals.slowAsteroids = true
	},

	"critical_hit": {
		"price": 120,
		"title": "Critical Clicks",
		"description": "Your clicks have a 25% chance to yield double starpoints.",
		"effect": func():
	Globals.critEnabled = true
	},

	"soften_asteroids": {
		"price": 150,
		"title": "Soften Asteroids",
		"description": "All asteroids have 1 less health",
		"effect": func():
	Globals.softenAsteroids = true
	},

	"passive_starpoints": {
		"price": 180,
		"title": "Passive Starpoints",
		"description": "Earn 1 starpoint every few seconds automatically.",
		"effect": func():
	Globals.passiveStarpoints = true
	},

	"binoculars": {
		"price": 200,
		"title": "Binoculars Mode",
		"description": "View expands based on your cursor position.",
		"effect": func():
	Globals.binocularsEnabled = true
	},

	"overkill": {
		"price": 300,
		"title": "Overkill Mode",
		"description": "Excess damage gives bonus starpoints",
		"effect": func():
	Globals.overkillEnabled = true
	},

	"life_steal": {
		"price": 500,
		"title": "Life Steal",
		"description": "Gain a life every 5 asteroids broken.",
		"effect": func():
	Globals.lifeSteal = true
	}
}

func _on_upgrade_button_pressed(button_name):
	button_name = button_name.replace("\"", "")
	
	var button = get_node(button_name)

	
	var upgrade_name = button.name
	var upgrade = upgrades.get(upgrade_name)
	
	if upgrade and not button.disabled:
		var price = upgrade.price
		if Globals.starPoints >= price:
			Globals.starPoints -= price
			upgrade.effect.call()
			button.disabled = true
			print("Obtained " + upgrade.title + " upgrade for " + str(upgrade.price) + " starpoints!",
					"\nTitle: " + upgrade.title +
					"\nDescription: " + upgrade.description +
					"\nPrice: " + str(upgrade.price)
					)

var original_scale = Vector2.ONE
var hover_scale = Vector2(1.2, 1.2)

func _on_button_mouse_entered(button_name):
	button_name = button_name.replace("\"", "")
	
	var button = get_node(button_name)
	var label = get_node(button_name + "/" + button_name + "_label")
	var upgrade = upgrades.get(button.name)
	
	original_scale = button.scale
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", hover_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	label.text = upgrade.title + "\n" + upgrade.description + "\n[" + str(upgrade.price) + " Starpoints]"
	label.visible = true
	await get_tree().process_frame  # Wait one frame
	label.position = Vector2((button.size.x - label.size.x) / 2, -label.size.y - 10)  # Offset upward
	
	
	
func _on_button_mouse_exited(button_name):
	button_name = button_name.replace("\"", "")
	
	var button = get_node(button_name)
	var label = get_node(button_name + "/" + button_name + "_label")
	label.visible = false
	
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", original_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
