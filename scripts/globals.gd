extends Node2D

var lives : int = 50
var starPoints : int = 0
var shopOpened : bool = false
var volume : float = 0
var clickDamage : int = 1
var baseYield : int = 100
var yieldMultiplier : int = 1
var critMultiplier : int = 1 # Such that a critMultiplier of n will yield n+1 starpoints
var critEnabled : bool = false
var binocularsEnabled : bool = false
