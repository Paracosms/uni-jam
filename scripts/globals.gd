extends Node2D

# code helpers - on ready, values are initialized correctly
var centerScreen : Vector2
var screenSize : Vector2
var parallaxSpeed: float = 0.2
var meteorShower : bool = false

var lives : int = 1
var starPoints : int = 0
var currentStar : int = 0 # such that alpha = 0, beta = 1, etc.
var shopOpened : bool = false
var volume : float = 0
var clickDamage : int = 1
var baseYield : int = 100
var yieldMultiplier : int = 1
var critMultiplier : int = 1 # Such that a critMultiplier of n will yield n+1 starpoints

# star unlocks
var betaUnlocked : bool = true # left, 2nd planet unlock
var gammaUnlocked : bool = true # top, 3rd planet unlock
var deltaUnlocked : bool = true # right, 4th planet unlock

# special upgrades
var critEnabled : bool = false
var binocularsEnabled : bool = false
var crushSmall : bool = false
var slowAsteroids : bool = false
var softenAsteroids : bool = false
var passiveStarpoints : bool = false
var overkillEnabled : bool = false
var lifeSteal : bool = false

func _process(_delta):
	screenSize = get_viewport().get_visible_rect().size
	centerScreen = Vector2(screenSize.x / 2,screenSize.y / 2)
