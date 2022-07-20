tool
extends Node2D

class_name Monitor

export(String, "none", "ring", "speed", "fire", "lightning", "bubble", "invincibility", "eggman") var type:String = "none"
var oldType:String = ""

var is_destroyed:bool = false
var body

func _ready():
	$icon.play(type)

func _process(delta):
	if oldType != type:
		oldType = type
		$icon.play(type)

func _on_Area2D_body_entered(body):
	if not is_destroyed and body is Character:
		if body.is_rolling:
			if not is_destroyed:
				var initial_velocity = body.velocity.x
				is_destroyed = true
				$StaticBody2D/CollisionShape2D.queue_free()
				$StaticBody2D.queue_free()
				$Area2D.queue_free()
				$Area2D2.queue_free()
				$AnimationPlayer.play("broken")
				
				$Destroy.play()
				
				get_item()

func _on_Area2D2_body_entered(body):
	if not is_destroyed and body is Character:
		if body.is_jumping:
			if not is_destroyed:
				is_destroyed = true
				$StaticBody2D.queue_free()
				$Area2D.queue_free()
				$Area2D2.queue_free()
				$AnimationPlayer.play("broken")
				
				Audio.playSFX("destroy_badnik")
				
				get_item()
				
				body.velocity.y = -body.jumpForce/1.2
				
func get_item():
	yield(get_tree().create_timer(0.5), "timeout")
	match type:
		"ring":
			Audio.playSFX("ring")
			Global.rings += 10
			if Global.rings > 999:
				Global.rings = 999
		"fire":
			Audio.playSFX("fire_shield")
		"lightning":
			Audio.playSFX("lightning_shield")
		"bubble":
			Audio.playSFX("bubble_shield")
