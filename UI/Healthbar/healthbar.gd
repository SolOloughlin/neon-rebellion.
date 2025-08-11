extends Node2D

@export var heart1 : Texture2D
@export var heart0 : Texture2D

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3

@onready var death_screen : Sprite2D = $"../Gta5Death"
@onready var death_sound : AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

func _ready() -> void:
	HealthManager.on_health_changed.connect(on_player_health_changed)
	print("connected signals healthbar")
	death_screen.visible = false



func on_player_health_changed(player_current_health : int):
	if player_current_health == 3:
		heart_3.texture = heart1
	elif player_current_health < 3:
		heart_3.texture = heart0
		
	if player_current_health == 2:
		heart_2.texture = heart1
	elif player_current_health < 2:
		heart_2.texture = heart0
	
	if player_current_health == 1:
		heart_1.texture = heart1
	elif player_current_health < 1:
		heart_1.texture = heart0
	
	if player_current_health == 0:
		death_screen.visible = true
		death_sound.play()
