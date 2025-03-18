extends CharacterBody2D

@export var speed = 200.0  # Enemy movement speed in pixels/second
@export var attack_distance = 100.0  # Distance to trigger attack in pixels
@export var damage = 25  # Damage dealt to player per hit
@onready var player = Global.player  # Reference to player
@onready var animated_sprite = $AnimatedSprite2D  # Reference to AnimatedSprite2D
var is_attacking = false
var can_attack = true  # Cooldown flag for collision
var has_hit = false  # Flag to ensure damage is dealt only once per attack

func _ready():
	if not player:
		print("Warning: Player node not found at /root/main/Node2D/CharacterBody2D")
	else:
		print("Player found: ", player)

func _physics_process(_delta):
	if not is_attacking and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		# Flip sprite based on direction
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
		
		# Play run animation while moving
		if velocity.length() > 0 and animated_sprite.animation != "run":
			animated_sprite.play("run")
		
		# Check distance to player and trigger attack
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= attack_distance:
			attack()
	elif not player:
		velocity = Vector2.ZERO
		if animated_sprite.animation != "run":
			animated_sprite.play("run")

func attack():
	is_attacking = true
	has_hit = false  # Reset hit flag at the start of the attack
	velocity = Vector2.ZERO
	if animated_sprite.sprite_frames.has_animation("attack"):
		animated_sprite.play("attack")
		# Check for hit during the animation (e.g., at a specific frame or midpoint)
		await get_tree().create_timer(0.2).timeout  # Delay to simulate attack "hit" timing
		check_hit()  # Check if player is hit
		await animated_sprite.animation_finished
	else:
		print("Error: 'attack' animation not found in AnimatedSprite2D")
		await get_tree().create_timer(0.5).timeout  # Fallback
	is_attacking = false

func check_hit():
	# Check if player is still in range or colliding with Area2D
	if player and global_position.distance_to(player.global_position) <= attack_distance and not has_hit:
		if player.has_method("take_damage"):
			await get_tree().create_timer(0.6).timeout
			player.take_damage(damage)
			has_hit = true  # Prevent multiple hits in one attack


func _on_area_2d_body_entered(body):
	if body == player and not is_attacking and can_attack:
		attack()
		can_attack = false
		await get_tree().create_timer(1.0).timeout  # 1-second cooldown
		can_attack = true
