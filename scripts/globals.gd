extends Node2D

var lives : int = 100
var starPoints : int = 0
var clickDamage : int = 1
var baseYield : int = 100
var yieldMultiplier : float = 1
var critMultiplier : float = 1 # Such that a critMultiplier of n will yield n+1 starpoints
var critEnabled : bool = false
