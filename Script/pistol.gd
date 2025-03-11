extends Node2D

@export var bullet_scene: PackedScene  # Assign your bullet scene in the Inspector

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()  # Create a bullet instance
	var mouse_pos = get_global_mouse_position()  # Get mouse position
	var direction = (mouse_pos - global_position).normalized()  # Calculate direction
	
	bullet.global_position = global_position  # Spawn bullet at gun position
	bullet.direction = direction  # Set bullet direction

	get_tree().current_scene.add_child(bullet)  # Add bullet to scene
