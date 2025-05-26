extends CharacterBody2D


@export var GRAVITY = 1000
@export var SPEED = 300
@export var JUMP = -300
@export var JUMP_HORIZONTAL = 100
@export var jump_horizontal_speed: int = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed: int = 1700
enum State { Idle, Run, Jump }

var current_state : State

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	current_state = State.Idle





func _physics_process(delta : float):
	player_falling(delta)
	_player_idle(delta)
	_player_run(delta)
	_player_jump(delta)
	move_and_slide()
	
	_player_animations(delta)


func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func _player_idle(delta : float):
	if is_on_floor():
		current_state = State.Idle


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
	if Input.is_action_just_pressed("move_up"):
		velocity.y = JUMP
		current_state = State.Jump

	if !is_on_floor() and current_state == State.Jump:
		var direction = _input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
func _player_animations(delta : float):
	if current_state == State.Idle:
		animation.play("Idle")
	elif current_state == State.Run:
		animation.play("Run")
	elif current_state == State.Jump:
		animation.play("Jump")

func _input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction
