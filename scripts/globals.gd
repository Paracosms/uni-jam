extends Node2D

var lives : int = 50
var starPoints : int = 0
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
var crushSmall : bool = false
var slowAsteroids : bool = false
var softenAsteroids : bool = false
var passiveStarpoints : bool = false
var overkillEnabled : bool = false
var lifeSteal : bool = false
