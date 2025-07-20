extends PanelContainer

signal resetGame

func _ready():
	%retry.pressed.connect(retry)
	%exit.pressed.connect(exitToMainMenu)
	get_tree().current_scene.connect("gameOver", showDeathUI)

func showDeathUI():
	
	# Disable Shop
	if Globals.skillsOpened:
		$/root/Main.toggleSkills()
	$/root/Main/UIRenderer/UI/windowScale/Info/centerLeft/toggleSkills.visible = false
	
	visible = true
	%retry.disabled = false
	%exit.disabled = false

func hideDeathUI():
	visible = false
	%retry.disabled = true
	%exit.disabled = true
	
	$/root/Main/UIRenderer/UI/windowScale/Info/centerLeft/toggleSkills.visible = true

func resetGlobals():
	Globals.parallaxSpeed = 0.2
	Globals.meteorShower = false
	
	Globals.lives = 50
	Globals.starPoints = 0
	Globals.currentStar = 0 # such that alpha = 0, beta = 1, etc.
	Globals.currentSkillTree = 0 # 0 - Lyra, 1 - Cepheus 2 - Perseus
	Globals.skillsOpened = false
	Globals.volume = 0
	Globals.clickDamage = 1 ### Done
	Globals.baseYield = 1 ### Done
	Globals.currentKills = 0 # Current number of kills to compare to lifeSteal

	# star unlocks
	Globals.betaUnlocked = false # left, 2nd planet unlock ### Done
	Globals.gammaUnlocked = false # top, 3rd planet unlock ### Done
	Globals.deltaUnlocked = false # right, 4th planet unlock ### Done

	# special upgrades
	Globals.critical_hit = 0.0 # %Float chance that starpoints are doubled ### Done
	Globals.binocularsEnabled = false # Allows user to see additional 100 pixels ### Done
	Globals.crushSmall = 0.3 # If asteroid is below float, destroy it instantly ### Done
	Globals.slowAsteroids = 0.0 # Slow all asteroids down %float ### DONE
	Globals.softenAsteroids = 0 # All asteroids have int less health ### DONE
	Globals.passiveStarpoints = 0 # Gain int starpoints every 3 seconds ### DONE
	Globals.overkill = 0 # Every 1 damage over necessary to kill rewards int starpoints ### DONE
	Globals.lifeSteal = 9223372036854775807 # Gain a life every int asteroids broken ### DONE

func exitToMainMenu():
	Globals.playSelectSound()
	resetGlobals()
	hideDeathUI()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func retry():
	Globals.playSelectSound()
	resetGlobals()
	emit_signal("resetGame")
	hideDeathUI()
