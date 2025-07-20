extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _process(_delta):
	var scaleFactor = Globals.screenSize.y / 1440.0
	%background.scale = Vector2(scaleFactor, scaleFactor) 
	if %background.position.x < -Globals.screenSize.x / 2:
		%background.position.x += 4794 * scaleFactor
	else: %background.position.x -= 0.2
	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_options_pressed():
	print("We can do this later")
	
func _on_quit_pressed():
	get_tree().quit()
