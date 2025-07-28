extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@export var target_level : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("area entered")
	animated_sprite_2d.play("disappear")
	get_tree().change_scene_to_packed(target_level)
