extends Control

func _process(_delta):
	var lives = Globals.lives
	var starPoints = Globals.starPoints
	
	%lives.text = str(lives)
	%starpoints.text = str(starPoints)
