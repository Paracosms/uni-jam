extends Node2D

# code helpers - on ready, values are initialized correctly
var centerScreen : Vector2
var screenSize : Vector2

var lives : int = 50
var starPoints : int = 0
var currentStar : int = 0 # such that alpha = 0, beta = 1, etc.
var shopOpened : bool = false
var volume : float = 0
var clickDamage : int = 1
var baseYield : int = 100
var yieldMultiplier : int = 1
var critMultiplier : int = 1 # Such that a critMultiplier of n will yield n+1 starpoints

# star unlocks
var betaUnlocked : bool = false # left, 2nd planet unlock
var gammaUnlocked : bool = false # top, 3rd planet unlock
var deltaUnlocked : bool = false # right, 4th planet unlock

# special upgrades
var critEnabled : bool = false
var binocularsEnabled : bool = false

<<<<<<< Updated upstream
=======
func _process(_delta):
	screenSize = get_viewport().get_visible_rect().size
	centerScreen = Vector2(screenSize.x / 2,screenSize.y / 2)
>>>>>>> Stashed changes
