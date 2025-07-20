extends PanelContainer

func _ready():
	%retry.pressed.connect(retry)
	%exit.pressed.connect(exitToMainMenu)
	get_tree().current_scene.connect("gameOver", showDeathUI)

func showDeathUI():
	visible = true
	%retry.disabled = false
	%exit.disabled = false

func exitToMainMenu():
	get_tree().quit()

func retry():
	# Reset Globals to default
	Globals.parallaxSpeed = 0.2
	Globals.meteorShower = false
	
	Globals.lives = 50
	Globals.starPoints = 0
	Globals.currentStar = 0 # such that alpha = 0, beta = 1, etc.
	Globals.skillsOpened = false
	Globals.volume = 0
	Globals.clickDamage = 1
	Globals.baseYield = 1
	Globals.yieldMultiplier = 1
	Globals.critMultiplier = 1 # Such that a critMultiplier of n will yield n+1 starpoints
	
	# star unlocks
	Globals.betaUnlocked = false # left, 2nd planet unlock
	Globals.gammaUnlocked = false # top, 3rd planet unlock
	Globals.deltaUnlocked = false # right, 4th planet unlock

	# special upgrades
	Globals.critEnabled = false
	Globals.binocularsEnabled = false
	Globals.crushSmall = false
	Globals.slowAsteroids = false
	Globals.softenAsteroids = false
	Globals.passiveStarpoints = false
	Globals.overkillEnabled = false
	Globals.lifeSteal = false
	
