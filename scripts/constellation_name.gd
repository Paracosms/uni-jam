extends Label

# originally 1234567890abcdefghjklmnopqrstuvwxyz~@#$%^&*()-=_+
# 35-39px width: 23456890abdeghnopqu$^
# 36px width: 69abdghnpqu$
var obfuscatedText : String = "69abdghnpqu$" # originally 1234567890abcdefghjklmnopqrstuvwxyz~@#$%^&*()-=_+

func _process(_delta):
	text = "CONSTELLATION: " + obfuscatedCharacters()

func obfuscatedCharacters() -> String:
	if Globals.deltaUnlocked:
		return "CRUX"
	if Globals.gammaUnlocked:
		return "CRU" + obfuscatedText[randi() % obfuscatedText.length()]
	if Globals.betaUnlocked:
		return "CR" + obfuscatedText[randi() % obfuscatedText.length()] + obfuscatedText[randi() % obfuscatedText.length()]
	else:
		return "C" + obfuscatedText[randi() % obfuscatedText.length()] + obfuscatedText[randi() % obfuscatedText.length()] + obfuscatedText[randi() % obfuscatedText.length()]
