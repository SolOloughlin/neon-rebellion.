extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"."



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	animated_sprite_2d.play("disappear")
