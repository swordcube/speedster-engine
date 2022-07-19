extends Node2D

func _ready():
	$AnimatedSprite.play("default")

func _on_Area2D_body_entered(body):
	if body is Character:
		Global.rings += 1
		if Global.rings > 999:
			Global.rings = 999
		queue_free()
