extends Node2D

# code helpers - on ready, values are initialized correctly
var centerScreen : Vector2
var screenSize : Vector2
var parallaxSpeed: float = 0.2
var meteorShower : bool = false

var lives : int = 1000
var starPoints : int = 10000
var currentStar : int = 0 # such that alpha = 0, beta = 1, etc.
var currentShot : int = 0 # 0 - Lyra, 1 - Cepheus 2 - Perseus
var skillsOpened : bool = false
var volume : float = 0
var clickDamage : int = 1 ### Done
var baseYield : int = 1 ### Done
var currentKills : int = 0 # Current number of kills to compare to lifeSteal

# star unlocks
var betaUnlocked : bool = true # left, 2nd planet unlock ### Done
var gammaUnlocked : bool = true # top, 3rd planet unlock ### Done
var deltaUnlocked : bool = true # right, 4th planet unlock ### Done

# special upgrades
var critical_hit : float = 0.0 # %Float chance that starpoints are doubled ### Done
var binocularsEnabled : bool = false # Allows user to see additional 100 pixels ### Done
var crushSmall : float = 0.3 # If asteroid is below float, destroy it instantly ### Done
var slowAsteroids : float = 0.0 # Slow all asteroids down %float ### DONE
var softenAsteroids : int = 0 # All asteroids have int less health ### DONE
var passiveStarpoints : int = 0 # Gain int starpoints every 3 seconds ### DONE
var overkill : int = 0 # Every 1 damage over necessary to kill rewards int starpoints ### DONE
var lifeSteal : int = 1000000 # Gain a life every int asteroids broken ### DONE



func _process(_delta):
	screenSize = get_viewport().get_visible_rect().size
	centerScreen = Vector2(screenSize.x / 2,screenSize.y / 2)
