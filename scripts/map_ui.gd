extends Panel

signal alphaClicked
signal betaClicked
signal gammaClicked
signal deltaClicked

func alphaClickHandler():
	emit_signal("alphaClicked")

func betaClickHandler():
	emit_signal("betaClicked")

func gammaClickHandler():
	emit_signal("gammaClicked")

func deltaClickHandler():
	emit_signal("deltaClicked")
