extends Node2D

onready var scoreNumbers:Array = [
	$"score/0",
	$"score/1",
	$"score/2",
	$"score/3",
	$"score/4",
	$"score/5"
]

onready var timeNumbers:Array = [
	$"time/0",
	$"time/1",
	$"time/2"
]

onready var ringNumbers:Array = [
	$"rings/0",
	$"rings/1",
	$"rings/2"
]

func _process(delta):
	var score:String = Global.get_string_with_digits(Global.score, 6)
	for i in scoreNumbers.size():
		var frame:int = int(score[i]) if score[i] != "A" else 10
		scoreNumbers[i].set_frame(frame)
		
	var time:String = format_time(Global.time)
	for i in timeNumbers.size():
		var frame:int = int(time[i])
		timeNumbers[i].set_frame(frame)
		
	var rings:String = Global.get_string_with_digits(Global.rings, 3)
	for i in ringNumbers.size():
		var frame:int = int(rings[i]) if rings[i] != "A" else 10
		ringNumbers[i].set_frame(frame)
		
func format_time(seconds:float):
	var timeString:String = str(int(seconds / 60))
	var timeStringHelper:String = str(int(seconds) % 60)
	if len(timeStringHelper) == 1:
		timeStringHelper = "0"+timeStringHelper
		
	return timeString+timeStringHelper
