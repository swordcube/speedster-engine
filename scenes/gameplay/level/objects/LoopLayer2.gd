extends Node2D

func _on_Area2D_body_entered(body):
	if body is Character:
		body.collision_layer = 2
