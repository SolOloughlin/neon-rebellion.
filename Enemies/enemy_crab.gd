extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer



@export var patrol_points : Node
@export var GRAVITY = 1000
@export var SPEED = 1500
@export var WAIT_TIME : int = 3
enum State { Idle, Walk }
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool


func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points?")
	timer.wait_time = WAIT_TIME
	current_state = State.Idle

func _physics_process(delta: float):
	_enemy_gravity(delta)
	_enemy_idle(delta)
	_enemy_walk(delta)
	
	move_and_slide()
	
	_enemy_animations()
func _enemy_gravity(delta: float):
	velocity.y += GRAVITY * delta

func _enemy_idle(delta : float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = State.Idle

func _enemy_walk(delta : float):
	if !can_walk:
		return
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else:
		current_point_position += 1

		if current_point_position >= number_of_points:
			current_point_position = 0

		current_point = point_positions[current_point_position]

		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
			
		can_walk = false
		timer.start()

	animated_sprite_2d.flip_h = direction.x > 0


func _on_timer_timeout() -> void:
	can_walk = true

func _enemy_animations():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("Walk")
