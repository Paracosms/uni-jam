extends Node2D

@onready var selectAudio = preload("res://assets/audio/select.wav")

# code helpers - on ready, values are initialized correctly
var centerScreen : Vector2
var screenSize : Vector2
var parallaxSpeed: float = 0.2
var meteorShower : bool = false
var lastStarDiedOn : int

var lives : int = 100
var starPoints : int = 09999
var currentStar : int = 0 # such that alpha = 0, beta = 1, etc.
var currentSkillTree : int = 0 # 0 - Lyra, 1 - Cepheus 2 - Perseus
var skillsOpened : bool = false
var volume : float = 0
var clickDamage : int = 1 ### Done
var baseYield : int = 1 ### Done
var planetYield : int = 0
var currentKills : int = 0 # Current number of kills to compare to lifeSteal
var asteroidSpawnTime : float = 1 # Every [value] seconds, an asteroid will spawn

# star unlocks
var betaUnlocked : bool = false # left, 2nd planet unlock ### Done
var gammaUnlocked : bool = false # top, 3rd planet unlock ### Done
var deltaUnlocked : bool = false # right, 4th planet unlock ### Done

# special upgrades
var critical_hit : float = 0.0 # %Float chance that starpoints are doubled ### Done
var binocularsEnabled : bool = false # Allows user to see additional 100 pixels ### Done
var crushSmall : float = 0.3 # If asteroid is below float, destroy it instantly ### Done
var slowAsteroids : float = 0.0 # Slow all asteroids down %float ### DONE
var softenAsteroids : int = 0 # All asteroids have int less health ### DONE
var passiveStarpoints : int = 0 # Gain int starpoints every 3 seconds ### DONE
var overkill : int = 0 # Every 1 damage over necessary to kill rewards int starpoints ### DONE
var lifeSteal : int = 9223372036854775807 # Gain a life every int asteroids broken ### DONE

func _process(_delta):
	screenSize = get_viewport().get_visible_rect().size
	centerScreen = Vector2(screenSize.x / 2,screenSize.y / 2)
	
	match currentStar:
		1: 
			planetYield = 5
			asteroidSpawnTime = 0.8
		2: 
			planetYield = 10
			asteroidSpawnTime = 0.6
		3: 
			planetYield = 20
			asteroidSpawnTime = 0.4

func playSelectSound():
	var soundPlayer = AudioStreamPlayer.new()
	soundPlayer.stream = selectAudio
	soundPlayer.volume_db = Globals.volume
	add_child(soundPlayer)
	soundPlayer.play()
	soundPlayer.finished.connect(soundPlayer.queue_free)
