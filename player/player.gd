extends CharacterBody2D




@export var GRAVITY = 1000
@export var SPEED = 300
@export var JUMP = -300
@export var JUMP_HORIZONTAL = 100
@export var jump_horizontal_speed: int = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed: int = 1700
enum State { Idle, Run, Jump, ShootUp, RunShoot, StandShoot, Hurt, }

var current_state : State
var bullet = preload("res://Bullet/bullet.tscn")
var muzzle_position
var max_jump = 2
var jump_count = 0
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle


func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position




func _physics_process(delta : float):
	player_falling(delta)
	_player_idle(delta)
	_player_run(delta)
	_player_jump(delta)
	_muzzle_position()
	_run_shoot(delta)
	_stand_shoot(delta)
	
	move_and_slide()
	
	_player_animations(delta)




func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func _player_idle(delta : float):
	if is_on_floor():
		current_state = State.Idle


func _run_shoot(delta):
	var direction = _input_movement()
	print("direction:",direction)
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		_shoot_bullet()
		current_state = State.RunShoot

func _shoot_bullet():
	var direction = _input_movement()
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.direction = direction
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)


func _muzzle_position():
	var direction = _input_movement()
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x

func _stand_shoot(delta):
	var direction = _input_movement()
	var shoot_direction = _shoot_direction()
	print("shoot_direction:", shoot_direction)
	if direction == 0 and Input.is_action_just_pressed("shoot"):
		_shoot_bullet()
		current_state = State.StandShoot
		print("stand-shoot")
	
func _player_run(delta : float):
	var direction = _input_movement()
	
	if direction:
		velocity.x += direction * SPEED* delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	
	if direction != 0 and velocity.y == 0:
		current_state = State.Run
		animation.flip_h = false if direction > 0 else true

func _player_jump(delta : float):
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("move_up") and jump_count < max_jump:
		velocity.y = JUMP
		current_state = State.Jump
		jump_count += 1


	if !is_on_floor() and current_state == State.Jump:
		var direction = _input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
func _player_animations(delta : float):
	if current_state == State.Idle and animation.animation != "Stand-Shoot":
		animation.play("Idle")
	elif current_state == State.Run and animation.animation != "Run-Shoot":
		animation.play("Run")
	elif current_state == State.Jump:
		animation.play("Jump")
	elif current_state == State.RunShoot:
		animation.play("Run-Shoot")
	elif current_state == State.StandShoot:
		animation.play("Stand-Shoot")

func _input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction

func _shoot_direction():
	var direction = _input_movement()
	var shoot_direction : float = 1
	if direction != 0:
		shoot_direction = direction
	if shoot_direction == 0 and shoot_direction != -1:
		shoot_direction = 1
	return shoot_direction
