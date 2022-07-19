extends Node2D

func _ready():
	$Dust.play("default")

func _on_Dust_animation_finished():
	queue_free()
