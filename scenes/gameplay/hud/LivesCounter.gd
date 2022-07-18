extends Node2D

onready var liveNumbers:Array = [
	$"Numbers/0",
	$"Numbers/1",
]

func _process(delta):
	var lives:String = Global.get_string_with_digits(Global.lives, 2)
	for i in liveNumbers.size():
		var frame:int = int(lives[i]) if lives[i] != "A" else 10
		liveNumbers[i].set_frame(frame)
