extends Node2D

@export var projectile_scene: PackedScene
@export var shoot_cooldown: float = 0.2
@export var projectile_speed: float = 800.0
@export var damage: float = 10.0
var can_shoot: bool = true
var timer: float = 0.0

func _process(delta: float) -> void:
	# Update mouse position and angle every frame
	var mouse_pos = get_global_mouse_position()
	var angle = (mouse_pos - global_position).angle()
	global_rotation = angle
	
	# Flip sprite only, not the entire node
	if angle > PI/2 and angle < 3*PI/2:
		$Weapon.scale.y = -1
	else:
		$Weapon.scale.y = 1
	
	# Handle cooldown
	if not can_shoot:
		timer -= delta
		if timer <= 0:
			can_shoot = true
	
	# Shoot
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	if projectile_scene == null:
		push_error("Projectile scene not assigned!")
		return
	var projectile = projectile_scene.instantiate()
	if !is_instance_valid(projectile):
		push_error("Failed to instantiate projectile!")
		return
	get_tree().root.add_child(projectile)
	var marker = $Marker2D
	if marker == null:
		push_error("Marker2D node not found!")
		return
	projectile.global_position = marker.global_position
	projectile.rotation = global_rotation
	projectile.z_index = 1 # Ensure visibility
	if projectile.has_method("set_velocity"):
		projectile.set_velocity(projectile_speed, damage)
	else:
		push_error("Projectile missing set_velocity method!")
	can_shoot = false
	timer = shoot_cooldown
	print("Shot fired, cooldown: ", shoot_cooldown)
