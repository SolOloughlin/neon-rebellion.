extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@export var target_level : PackedScene

var body_entered : bool

func _ready() -> void:
	body_entered = false


# Called when the node enters the scene tree for the first time.
func _on_area_2d_body_entered(body: Node2D) -> void:
	body_entered = true
	animated_sprite_2d.play("disappear")
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_packed(target_level)
	
