extends Node2D

onready var camera = $Camera2D

var level:Node2D = Global.loadedLevel
var player:Character = level.get_node("Player")

func _ready():
	Global.time = 0.0
	add_child(level)
	
	position_camera()
	
var your_mom_timer:float = 0.0
	
func _process(delta):
	Global.time += delta
	position_camera()
	
	if player.position.y > 10000:
		OS.kill(OS.get_process_id())
	
	if player.is_looking_up or player.is_ducking:
		your_mom_timer += delta
		if your_mom_timer > 2:
			camera.offset.y = lerp(camera.offset.y, 50 if player.is_ducking else -50, delta*5)
	else:
		your_mom_timer = 0.0
		camera.offset.y = lerp(camera.offset.y, 0, delta*5)
	
func position_camera():
	camera.position = player.position
	if camera.position.x < 640:
		camera.position.x = 640
