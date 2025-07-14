extends AnimatedSprite2D

@export var speed: int = 600
@export var direction: float

func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)

func _on_timer_timeout() -> void:
	queue_free()
