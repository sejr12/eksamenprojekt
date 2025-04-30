extends Node

@onready var health_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/HealthLabel
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D  
@onready var health_bar: TextureProgressBar = $CanvasLayer/MarginContainer2/health_bar
@onready var stamina_bar: TextureProgressBar = $CanvasLayer/MarginContainer2/stamina_bar
@onready var scorelabel: Label = $CanvasLayer/MarginContainer/VBoxContainer/scorelabel

func _ready():
	character_body_2d.stamina_updated.connect(update_stamina_bar) 
	update_stamina_bar(character_body_2d.current_stamina)  
	
	if character_body_2d.has_signal("health_updated"):  
		character_body_2d.health_updated.connect(update_health_label)  
		update_health_label(character_body_2d.health) 
	else:
		print("Error: 'health_updated' signal not found in CharacterBody2D!")

func update_health_label(health):
	health_label.text = "Health: " + str(health) 
	health_bar.max_value = character_body_2d.MAX_HEALTH  
	health_bar.value = health 
func update_stamina_bar(stamina):
	stamina_bar.value = stamina 

func update_score():
	scorelabel.text = "Score: " + str(Global.score)
