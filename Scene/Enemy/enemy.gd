extends CharacterBody2D

@export var speed = 200.0  # Enemy movement speed in pixels/second
@export var attack_distance = 100.0  # Distance to trigger attack in pixels
@onready var player = Global.player  # Correct path
@onready var animated_sprite = $AnimatedSprite2D  # Reference to your AnimatedSprite2D node
var is_attacking = false

func _ready():
	if not player:
		print("Warning: Player node not found at /root/main/Node2D/CharacterBody2D")
	else:
		print("Player found: ", player)

func _physics_process(delta):
	if not is_attacking and player:
		# Calculate direction to player
		var direction = (player.global_position - global_position).normalized()
		
		# Move towards player
		velocity = direction * speed
		move_and_slide()
		
		# Flip sprite based on direction
		if direction.x > 0:
			animated_sprite.flip_h = false  # Face right
		elif direction.x < 0:
			animated_sprite.flip_h = true  # Face left
		
		# Play run animation while moving
		if velocity.length() > 0 and not animated_sprite.is_playing():
			animated_sprite.play("run")
		
		# Check distance to player and trigger attack
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= attack_distance and not animated_sprite.is_playing():
			attack()
	else:
		# Stop movement if not attacking or no player
		velocity = Vector2.ZERO
		if not is_attacking and not animated_sprite.is_playing():
			animated_sprite.play("run")  # Default to run if not attacking

func attack():
	is_attacking = true
	velocity = Vector2.ZERO  # Stop movement during attack
	if animated_sprite.sprite_frames.has_animation("attack"):
		animated_sprite.play("attack")  # Play the attack animation
	else:
		print("Error: 'attack' animation not found in AnimatedSprite2D")
	await animated_sprite.animation_finished  # Wait for animation to finish
	is_attacking = false

# Called when enemy collides with something
func _on_area_2d_body_entered(body):
	if body == player and not is_attacking:
		attack()
