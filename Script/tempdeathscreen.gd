extends Control

@onready var scorelabel: Label = $VBoxContainer/scorelabel


func _ready():
	set_score(Global.last_score)



func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
	


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main.tscn")
	
func set_score(n: int):
	scorelabel.text = "Final Score: " + str(n)
	if n > Global.save_data.high_score:
		Global.save_data.high_score = n
		Global.save_data.save()
