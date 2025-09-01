extends Node

var max_health : int = 3
var current_health : int
@onready var death_sound : AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
signal on_health_changed
@export var target_level = PackedScene

func decrease_health(health_amount : int):
	current_health -= health_amount
	
	if current_health < 0:
		current_health = 0
	print("decrease health called, health:", current_health)
	on_health_changed.emit(current_health)


func increase_health(health_amount : int):
	current_health += health_amount
	
	if current_health > max_health:
		current_health = max_health
	print("increase health called, health:", current_health)
	on_health_changed.emit(current_health)

func _death_screen():
	if current_health == 0:
		get_tree().change_scene_to_packed(target_level)
		death_sound.play()
		print("opened death screen")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_death_screen()
