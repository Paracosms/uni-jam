extends Panel

signal alphaClicked
signal betaClicked
signal gammaClicked
signal deltaClicked

var allDisabled : bool = false

func _ready():
	%beta.disabled = true
	%gamma.disabled = true
	%delta.disabled = true
	
	%beta.visible = false
	%gamma.visible = false
	%delta.visible = false
	
	get_tree().current_scene.connect("disableTP", disableAllPlanets)
	get_tree().current_scene.connect("enableTP", enableAllPlanets)

# Current star is always unable to be travelled to
func _process(_delta):
	%alpha.disabled = false
	%beta.disabled = false
	%gamma.disabled = false
	%delta.disabled = false
	
	if Globals.betaUnlocked:
		%beta.disabled = false
		%beta.visible = true
	else:
		%beta.disabled = true
		%beta.visible = false
	
	if Globals.gammaUnlocked:
		%gamma.disabled = false
		%gamma.visible = true
	else:
		%gamma.disabled = true
		%gamma.visible = false
	
	if Globals.deltaUnlocked:
		%delta.disabled = false
		%delta.visible = true
	else:
		%delta.disabled = true
		%delta.visible = false
	
	
	if Globals.betaUnlocked && Globals.deltaUnlocked:
		%horizontal.visible = true
	else:
		%horizontal.visible = false
	
	if Globals.gammaUnlocked:
		%vertical.visible = true
	else:
		%vertical.visible = false
	
	match Globals.currentStar:
		0: %alpha.disabled = true
		1: %beta.disabled = true
		2: %gamma.disabled = true
		3: %delta.disabled = true
	
	if allDisabled || Globals.meteorShower:
		%alpha.disabled = true
		%beta.disabled = true
		%gamma.disabled = true
		%delta.disabled = true

func _on_mouse_entered(buttonName):
	print(buttonName)
	var hover_scale = Vector2(1.2, 1.2)
	var button = get_node(buttonName)
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", hover_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_mouse_exited(buttonName):
	var button = get_node(buttonName)
	var original_scale = Vector2.ONE
	
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.tween_property(button, "scale", original_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_pressed(star):
	match star:
		"alpha": 
			emit_signal("alphaClicked")
		"beta": 
			emit_signal("betaClicked")
		"gamma": 
			emit_signal("gammaClicked")
		"delta": 
			emit_signal("deltaClicked")

func disableAllPlanets():
	allDisabled = true

func enableAllPlanets():
	allDisabled = false
