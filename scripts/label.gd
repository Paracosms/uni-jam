extends Label

func _ready():
	text = "Lives: 100\nStar Points: 0" 
	
func _process(_delta):
	var lives = get_node("/root/Main/Globals").lives
	var starPoints = get_node("/root/Main/Globals").starPoints
	
	text = "Lives: " + str(lives) + "\nStar Points: " + str(starPoints)
