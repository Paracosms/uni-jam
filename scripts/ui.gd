extends SubViewportContainer

var volumeAnimation = preload("res://assets/resources/volume.tres")
var volumeStill = preload("res://assets/sprites/animations/volume2.png")


func _process(_delta):
	size = Vector2(Globals.screenSize.x , Globals.screenSize.y)
	#%windowScale.size.x = Globals.screenSize.x
	#%windowScale.size.y = Globals.screenSize.y
	
	var lives = Globals.lives
	var starPoints = Globals.starPoints
	
	%lives.text = str(lives)
	%starpoints.text = str(starPoints)

func _on_volume_ui_mouse_entered():
	%volumeIcon.texture = volumeAnimation

func _on_volume_ui_mouse_exited():
	%volumeIcon.texture = volumeStill

func _on_volume_mouse_entered():
	%volumeIcon.texture = volumeAnimation

func _on_volume_mouse_exited():
	%volumeIcon.texture = volumeStill
