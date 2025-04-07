# Weapon.gd
extends Node2D

@export var projectile_scene: PackedScene
@export var shoot_cooldown := 0.2
var can_shoot := true
var timer := 0.0

func _process(delta: float) -> void:
	# Look at mouse
	global_rotation = get_global_mouse_position().angle_to_point(global_position)
	
	# Handle cooldown
	if not can_shoot:
		timer -= delta
		if timer <= 0:
			can_shoot = true
	
	# Shoot
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.rotation = global_rotation
	can_shoot = false
	timer = shoot_cooldown
