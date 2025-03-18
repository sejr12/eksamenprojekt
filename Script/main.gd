extends Node

@onready var health_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/HealthLabel
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D  
@onready var stamina_bar: TextureProgressBar = $CanvasLayer/stamina_bar



func _ready():
	character_body_2d.stamina_updated.connect(update_stamina_bar)  # Connect signal
	update_stamina_bar(character_body_2d.current_stamina)  # Set initial value
	
	if character_body_2d.has_signal("health_updated"):  # Check if signal exists
		character_body_2d.health_updated.connect(update_health_label)  # Connect the signal
		update_health_label(character_body_2d.health)  # Set initial health value
	else:
		print("Error: 'health_updated' signal not found in CharacterBody2D!")

func update_health_label(health):
	health_label.text = "Health: " + str(health)  # Update UI text

func update_stamina_bar(stamina):
	stamina_bar.value = stamina  # Update stamina bar
