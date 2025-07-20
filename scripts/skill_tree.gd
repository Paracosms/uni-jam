extends Node2D

var upgrades = {
	### CRUSH SMALL ###
	"crush_small": {
		"price": 120,
		"title": "Crush Small Asteroids",
		"description": "Instantly destroy small asteroids with one click",
		"prerequisites": ["critical_hit", "slow_asteroids"],
		"effect": func():
	Globals.crushSmall = 0.4
	},
	"crush_small2": {
		"price": 100,
		"title": "Crush Small Asteroids II",
		"description": "Instantly destroy bigger asteroids with one click",
		"prerequisites": ["slow_asteroids2"],
		"effect": func():
	Globals.crushSmall = 0.5
	},
	
	### STARPOINT YIELD###
	"starpoint_yield": {
		"price": 10,
		"title": "Starpoint Hoarder",
		"description": "Breaking asteroids yields 2 starpoints instead of 1.",
		"prerequisites": [],
		"effect": func():
	Globals.baseYield = 2
	},
	"starpoint_yield2": {
		"price": 150,
		"title": "Starpoint Hoarder II",
		"description": "Breaking asteroids yields 3 starpoints instead of 2.",
		"prerequisites": ["crush_small2"],
		"effect": func():
	Globals.baseYield = 3
	},
	"starpoint_yield3": {
		"price": 500,
		"title": "Starpoint Hoarder III",
		"description": "Breaking asteroids yields 5 starpoints instead of 3.",
		"prerequisites": ["overkill"],
		"effect": func():
	Globals.baseYield = 5
	},
	"starpoint_yield4": {
		"price": 1000,
		"title": "Starpoint Hoarder IV",
		"description": "Breaking asteroids yields 10 starpoints instead of 5.",
		"prerequisites": ["slow_asteroids3"],
		"effect": func():
	Globals.baseYield = 10
	},

	### DAMAGE OUTPUT ###
	"damage_output": {
		"price": 40,
		"title": "Asteroid Miner",
		"description": "Your clicks deal 2 damage to asteroids.",
		"prerequisites": ["starpoint_yield"],
		"effect": func():
	Globals.clickDamage = 2
	},
	"damage_output2": {
		"price": 1500,
		"title": "Asteroid Miner II",
		"description": "Your clicks deal 3 damage to asteroids.",
		"prerequisites": ["starpoint_yield4"],
		"effect": func():
	Globals.clickDamage = 3
	},
	
	### SLOW ASTEROIDS ###
	"slow_asteroids": {
		"price": 50,
		"title": "Asteroid Tranquilizer",
		"description": "Asteroids fall 5% slower",
		"prerequisites": ["damage_output"],
		"effect": func():
	Globals.slowAsteroids = 0.05
	},
	"slow_asteroids2": {
		"price": 100,
		"title": "Slow Falling Asteroids II",
		"description": "Asteroids fall 10% slower",
		"prerequisites": ["beta"],
		"effect": func():
	Globals.slowAsteroids = 0.1
	},
	"slow_asteroids3": {
		"price": 600,
		"title": "Slow Falling Asteroids III",
		"description": "Asteroids fall 15% slower",
		"prerequisites": ["starpoint_yield3"],
		"effect": func():
	Globals.slowAsteroids = 0.15
	},
	
	### CRITICAL HIT ###
	"critical_hit": {
		"price": 100,
		"title": "Critical Clicks",
		"description": "Your clicks have a 25% chance to yield double starpoints.",
		"prerequisites": ["damage_output"],
		"effect": func():
	Globals.critical_hit = 0.25
	},
	"critical_hit2": {
		"price": 1500,
		"title": "Critical Clicks II",
		"description": "Your clicks have a 50% chance to yield double starpoints.",
		"prerequisites": ["slow_asteroids3"],
		"effect": func():
	Globals.critical_hit = 0.5
	},
	
	### SOFTEN ASTEROIDS ###
	"soften_asteroids": {
		"price": 150,
		"title": "Soften Asteroids",
		"description": "All asteroids have 1 less health",
		"prerequisites": ["passive_starpoints"],
		"effect": func():
	Globals.softenAsteroids = 1
	},
	"soften_asteroids2": {
		"price": 2000,
		"title": "Soften Asteroids II",
		"description": "All asteroids have 2 less health",
		"prerequisites": ["critical_hit2"],
		"effect": func():
	Globals.softenAsteroids = 2
	},
	
	### PASSIVE STARPOINTS ###
	"passive_starpoints": {
		"price": 200,
		"title": "Starpoints Factory",
		"description": "Earn 1 starpoint every 3 seconds automatically.",
		"prerequisites": ["starpoint_yield2"],
		"effect": func():
	Globals.passiveStarpoints = 1
	},
	"passive_starpoints2": {
		"price": 300,
		"title": "Starpoints Factory II",
		"description": "Earn 5 starpoints every 3 seconds automatically.",
		"prerequisites": ["soften_asteroids"],
		"effect": func():
	Globals.passiveStarpoints = 5
	},
	"passive_starpoints3": {
		"price": 1500,
		"title": "Starpoints Factory III",
		"description": "Earn 15 starpoints every 3 seconds automatically.",
		"prerequisites": ["starpoint_yield4"],
		"effect": func():
	Globals.passiveStarpoints = 15
	},
	
	### BINOCULARS ###
	"binoculars": {
		"price": 100,
		"title": "Binoculars",
		"description": "View expands based on your cursor position.",
		"prerequisites": ["crush_small"],
		"effect": func():
	Globals.binocularsEnabled = true
	},
	
	### OVERKILL ###
	"overkill": {
		"price": 400,
		"title": "Overkill",
		"description": "Excess damage gives 10 bonus starpoints",
		"prerequisites": ["life_steal","passive_starpoints"],
		"effect": func():
	Globals.overkill = 10
	},
	"overkill2": {
		"price": 2000,
		"title": "Overkill II",
		"description": "Excess damage gives 15 bonus starpoints",
		"prerequisites": ["damage_output2"],
		"effect": func():
	Globals.overkill = 15
	},
	"overkill3": {
		"price": 300,
		"title": "Overkill III",
		"description": "Excess damage gives 20 bonus starpoints",
		"prerequisites": ["damage_output2"],
		"effect": func():
	Globals.overkill = 20
	},
	
	### LIFE STEAL ###
	"life_steal": {
		"price": 500,
		"title": "Life Steal",
		"description": "Gain a life every 10 asteroids broken.",
		"prerequisites": ["starpoint_yield2"],
		"effect": func():
	Globals.lifeSteal = 10
	},
	"life_steal2": {
		"price": 2000,
		"title": "Life Steal II",
		"description": "Gain a life every 5 asteroids broken.",
		"prerequisites": ["soften_asteroids2"],
		"effect": func():
	Globals.lifeSteal = 5
	},
	
	### STARS ###
	"beta": {
		"price": 200,
		"title": "MIMOSA | BETA CRUCIS",
		"description": "Unlock Mimosa!",
		"prerequisites": ["crush_small","binoculars"],
		"effect": func():
	Globals.betaUnlocked = true
	},
	"gamma": {
		"price": 1000,
		"title": "GACRUX | GAMMA CRUCIS",
		"description": "Unlock Gacrux!",
		"prerequisites": ["life_steal","overkill"],
		"effect": func():
	Globals.gammaUnlocked = true
	},
	"delta": {
		"price": 4000,
		"title": "IMAI | DELTA CRUCIS",
		"description": "Unlock Imai!",
		"prerequisites": ["life_steal2","overkill2"],
		"effect": func():
	Globals.deltaUnlocked = true
	},
	
}

var purchases = []


func _ready():
	
	var buttons_list = get_tree().get_nodes_in_group("texture_buttons")
	for button in buttons_list:
		if button.name != "starpoint_yield":
			button.disabled = true

func _process(_delta):
	var buttons_list = get_tree().get_nodes_in_group("texture_buttons")
	
	for button in buttons_list:
		var upgrade = upgrades.get(button.name)
		
		var already_purchased = button.name in purchases
		
		var has_all_prereqs = true
		for req in upgrade.prerequisites:
			if req not in purchases:
				has_all_prereqs = false
				break
		
		button.disabled = not has_all_prereqs
		
		if already_purchased:
			button.modulate = Color(0.0,0.6,0.6,1)
			

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
			purchases.append(button.name)
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
	var label = get_node("tooltip")
	var upgrade = upgrades.get(button.name)
	
	original_scale = button.scale
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", hover_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	label.text = upgrade.title + "\n" + upgrade.description + "\n[" + str(upgrade.price) + " Starpoints]"
	label.visible = true
	await get_tree().process_frame  # Wait one frame
	
	
	label.global_position = button.get_global_position() + Vector2(
		(button.size.x - label.size.x) / 2,
		-label.size.y - 20  # slightly more vertical offset
	)

	
	
	
func _on_button_mouse_exited(button_name):
	button_name = button_name.replace("\"", "")
	
	var button = get_node(button_name)
	var label = get_node("tooltip")
	label.visible = false
	
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", original_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
