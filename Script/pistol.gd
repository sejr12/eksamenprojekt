extends Node2D

@onready var bullet_scene = preload("res://Scene/Guns and bullet/Bullet.tscn")

func _process(delta):
	look_at(get_global_mouse_position())  # Rotate the pistol towards the mouse

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()  # Create bullet instance
		var spawn_marker = $Sprite2D/Marker2D  # Get the Marker2D node (adjust path if needed)
		var direction = (get_global_mouse_position() - spawn_marker.global_position).normalized()  # Get shooting direction
		bullet.global_position = spawn_marker.global_position  # Spawn bullet at Marker2D position
		bullet.rotation = spawn_marker.global_rotation  # Set bullet rotation to match Marker2D
		bullet.direction = direction  # Ensure bullet has a direction variable (used in Bullet.gd)
		get_tree().current_scene.add_child(bullet)  # Add bullet to scene
	else:
		print("Error: Bullet scene not assigned!")
