extends Node

var loadedLevel:Node2D = load("res://scenes/gameplay/level/A1_TestZone.tscn").instance()

var time:float = 0.0
var rings:int = 0
var score:int = 0

var lives:int = 3

func get_string_with_digits(number:int = 0, digits:int = 7):
	var string:String = str(number)
	for i in digits:
		if len(string) < digits:
			string = "A"+string
			
	return string
