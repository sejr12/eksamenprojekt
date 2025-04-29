extends Control

@onready var highscorelabel: Label = $VBoxContainer/highscorelabel

func _ready() -> void:
	var high_score:int = Global.save_data.high_score
	highscorelabel.text = "High Score: " + str(high_score)
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://info.tscn")
