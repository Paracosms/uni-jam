extends SubViewportContainer

var volumeAnimation = preload("res://assets/resources/volume.tres")
var volumeStill = preload("res://assets/sprites/animations/volume2.png")

func _ready():
	get_tree().current_scene.connect("meteorShower", warnMeteorShower)
	get_tree().current_scene.connect("displayLocation", displayLocation)
	get_tree().current_scene.connect("hideInfoBox", hideInfoBox)
	%volumeIcon.texture = volumeStill

func _process(_delta):
	size = Vector2(Globals.screenSize.x , Globals.screenSize.y)
	#%windowScale.size.x = Globals.screenSize.x
	#%windowScale.size.y = Globals.screenSize.y
	
	var lives = Globals.lives
	var starPoints = Globals.starPoints
	
	%lives.text = str(lives)
	%starpoints.text = str(starPoints)

func warnMeteorShower():
	Globals.meteorShower = true
	%mapStatusPanel.visible = true
	flashTextInfo("METEOR SHOWER INCOMING !", 5)
	await get_tree().create_timer(10).timeout
	Globals.meteorShower = false
	%mapStatusPanel.visible = false

func hideInfoBox():
	%infoBox.visible = false

func displayLocation():
	match Globals.currentStar:
		0: flashTextInfo("ACRUX --- ALPHA CRUCIS", 0)
		1: flashTextInfo("MIMOSA --- BETA CRUCIS", 0)
		2: flashTextInfo("GACRUX --- GAMMA CRUCIS", 0)
		3: flashTextInfo("IMAI --- DELTA CRUCIS", 0)

func flashTextInfo(message : String, flashes : int = 5):
	%textInfo.text = message
	if flashes == 0:
		%infoBox.visible = true
		await get_tree().create_timer(10).timeout
		%infoBox.visible = false
		return
	
	for blink in flashes:
		%infoBox.visible = true
		await get_tree().create_timer(0.3).timeout
		%infoBox.visible = false
		await get_tree().create_timer(0.3).timeout

func _on_volume_ui_mouse_entered():
	%volumeIcon.texture = volumeAnimation

func _on_volume_ui_mouse_exited():
	%volumeIcon.texture = volumeStill

func _on_volume_mouse_entered():
	%volumeIcon.texture = volumeAnimation

func _on_volume_mouse_exited():
	%volumeIcon.texture = volumeStill
