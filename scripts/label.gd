extends Label

func _ready():
	text = "Lives: 100\nStar Points: 0" 
	
func _process(_delta):
	var lives = Globals.lives
	var starPoints = Globals.starPoints
	
	text = "Lives: " + str(lives) + "\nStar Points: " + str(starPoints)
