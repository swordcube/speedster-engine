extends KinematicBody2D

class_name Character

onready var sprite = $AnimatedSprite
onready var dust = $SpindashDust

export(Texture) var life_icon:Texture = preload("res://assets/images/characters/sonic/life_icon.png")
export(Texture) var lives_texture:Texture = preload("res://assets/images/characters/sonic/lives.png")
export(float) var speed:float = 0.0
export(float) var slipperyness:float = 0.0
export(float) var gravity:float = 0.0
export(float) var jumpForce:float = 0.0

var is_jumping:bool = false
var is_rolling:bool = false
var is_spindashing:bool = false
var is_ducking:bool = false
var is_looking_up:bool = false
var is_moving:bool = false

var lock_movement:bool = false
var lock_direction:String = "left"

var spindash_timer:float = 0.0

var velocity:Vector2 = Vector2.ZERO

func _physics_process(delta):	
	sprite.rotation = 0.0
	if is_on_floor():
		is_jumping = false
		rotation = get_floor_normal().angle() + PI/2
		if is_rolling:
			sprite.rotation = -rotation
	else:
		rotation = 0.0
		
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
				velocity.x += spindash_timer*90 if not sprite.flip_h else spindash_timer*-90
				is_rolling = true
				lock_movement = true
				
		is_moving = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
		if not lock_movement:
			if Input.is_action_pressed("move_left"):
				dust.scale.x = -2
				sprite.flip_h = true
				velocity.x -= speed
				
			if Input.is_action_pressed("move_right"):
				dust.scale.x = 2
				sprite.flip_h = false
				velocity.x += speed
			
	elif is_ducking or is_spindashing:
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			lock_movement = true
			is_spindashing = true
			spindash_timer += 5.0
			if spindash_timer > 30.0:
				spindash_timer = 30.0
			
	velocity.x *= slipperyness
	
	if abs(velocity.x) < 25 and not is_moving:
		is_rolling = false
		lock_movement = false
		velocity.x = 0
		
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
	elif abs(velocity.x) > 30:
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
