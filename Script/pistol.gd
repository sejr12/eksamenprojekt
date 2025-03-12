extends Node2D

const bullet =  preload("res://Scene/Guns and bullet/Bullet.tscn")
@onready var muzzle: Marker2D = $Sprite2D/Marker2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	rotation_degrees = wrapf(rotation_degrees, 0, 360)

	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else: 
		scale.y = 1

	if Input.is_action_pressed("fire") and bullet:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		get_tree().current_scene.add_child(bullet_instance)
		
