extends KinematicBody2D

class_name Character

onready var sprite:AnimatedSprite = $AnimatedSprite
onready var dust:AnimatedSprite = $SpindashDust

export(Texture) var life_icon:Texture = preload("res://assets/images/characters/sonic/life_icon.png")
export(Texture) var lives_texture:Texture = preload("res://assets/images/characters/sonic/lives.png")
export(float) var speed:float = 0.0
export(float) var speedCap:float = 0.0
export(float) var slipperyness:float = 0.0
export(float) var gravity:float = 0.0
export(float) var jumpForce:float = 0.0

var is_jumping:bool = false
var is_rolling:bool = false
var is_spindashing:bool = false
var is_ducking:bool = false
var is_looking_up:bool = false
var is_skidding:bool = false
var is_moving:bool = false

var hell:bool = false
var pain:bool = false

var lock_movement:bool = false
var lock_direction:String = "left"

var spindash_timer:float = 0.0

var velocity:Vector2 = Vector2.ZERO

func _physics_process(delta):	
	sprite.rotation = 0.0
	if is_on_floor():
		is_jumping = false
		rotation = lerp(rotation, get_floor_normal().angle() + PI/2, 0.35)
		if is_rolling:
			sprite.rotation = -rotation
	else:
		rotation = 0.0
		
	is_skidding = false
	spindash_timer = lerp(spindash_timer, 5, delta)
		
	if not Input.is_action_pressed("duck"):
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jumpForce
				is_jumping = true
				is_rolling = false
				lock_movement = false
				
			if is_spindashing:
				is_spindashing = false
				velocity.x += spindash_timer*50 if not sprite.flip_h else spindash_timer*-50
				is_rolling = true
				lock_movement = true
				hell = false
				pain = true
				
		is_moving = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		if not lock_movement:
			if Input.is_action_pressed("move_left"):
				sprite.flip_h = true
				velocity.x -= speed
				
				if not (is_rolling or is_jumping):
					if velocity.x < -speedCap:
						velocity.x = -speedCap
				else:
					if velocity.x < -(speedCap*1.5):
						velocity.x = -(speedCap*1.5)
						
				if velocity.x > 20 and not is_rolling:
					sprite.flip_h = not sprite.flip_h
					velocity.x *= 0.95
					is_skidding = true
				
			if Input.is_action_pressed("move_right"):
				sprite.flip_h = false
				velocity.x += speed
				
				if not (is_rolling or is_jumping):
					if velocity.x > speedCap:
						velocity.x = speedCap
				else:
					if velocity.x > speedCap*1.5:
						velocity.x = speedCap*1.5
						
				if velocity.x < -20 and not is_rolling:
					sprite.flip_h = not sprite.flip_h
					velocity.x *= 0.95
					is_skidding = true
			
	elif is_ducking or is_spindashing:
		if abs(velocity.x) < 25:
			if is_on_floor() and Input.is_action_just_pressed("jump"):
				hell = false
				lock_movement = true
				is_spindashing = true
				pain = false
				spindash_timer += 5.0
				if spindash_timer > 30.0:
					spindash_timer = 30.0
	else:
		if is_on_floor() and abs(velocity.x) > 55 and not lock_movement:
			hell = true
			lock_movement = true
			is_rolling = true
			pain = false
				
	if not is_moving or (not pain and (lock_movement or hell)):
		velocity.x *= slipperyness
	
	if abs(velocity.x) < 25:
		is_rolling = false
		if not is_moving:
			lock_movement = false
			hell = false
			velocity.x = 0
		
	dust.scale.x = -2 if sprite.flip_h else 2
	dust.visible = is_spindashing
	
	velocity.y += gravity
	
	var snap:Vector2 = Vector2.DOWN * 128 if not is_jumping else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true, 4, 0.9)

	play_animations()
	
func play_animations():
	is_ducking = false
	is_looking_up = false
	
	sprite.speed_scale = 1.0

	if not is_jumping and (not is_on_floor() and velocity.y > 0):
		is_rolling = false
		lock_movement = false
		sprite.play("fall")	
	elif is_rolling and (not is_on_floor() and velocity.y > 0):
		is_rolling = false
		lock_movement = false
		sprite.play("fall")	
	elif not (is_jumping or is_rolling) and abs(velocity.x) > 500:
		sprite.speed_scale = 1.5
		sprite.play("run")
	elif is_jumping or is_rolling:
		sprite.speed_scale = clamp(abs(velocity.x)/200.0, 1, 999)
		sprite.play("roll")
	elif is_spindashing:
		sprite.speed_scale = spindash_timer/5.0
		sprite.play("spindash")
	elif is_skidding:
		sprite.play("skid")
	elif not (is_rolling or is_ducking) and is_moving and abs(velocity.x) == 0:
		sprite.play("push")
	elif abs(velocity.x) > 0:
		sprite.speed_scale = clamp(abs(velocity.x)/300.0, 0.5, 1.5)
		sprite.play("walk")
	elif abs(velocity.x) < 30 and Input.is_action_pressed("duck"):
		is_ducking = true
		is_looking_up = false
		sprite.play("duck")
	elif abs(velocity.x) < 30 and Input.is_action_pressed("look_up"):
		is_ducking = false
		is_looking_up = true
		sprite.play("look-up")
	else:
		sprite.play("idle")
