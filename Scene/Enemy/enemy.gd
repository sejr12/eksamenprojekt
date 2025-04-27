extends CharacterBody2D

@export var speed = 200.0  # Enemy movement speed in pixels/second
@export var attack_distance = 100.0  # Distance to trigger attack in pixels
@export var damage = 25  # Damage dealt to player per hit
@export var health: int = 50  # Enemy health
@export var hurt_speed_modifier = 0.5  # Speed multiplier when hurt (1.0 = full speed, 0.5 = half speed)

@onready var player = Global.player  # Reference to player
@onready var animated_sprite = $AnimatedSprite2D  # Reference to AnimatedSprite2D
var is_attacking = false
var is_hurt = false
var is_dead = false
var can_attack = true
var has_hit = false
var score = 0
func _ready():
	if not player:
		print("Warning: Global.player is null for enemy at ", global_position)

func _physics_process(_delta):
	if not is_attacking and not is_dead and player:
		var direction = (player.global_position - global_position).normalized()
		# Apply hurt speed modifier if hurt, otherwise use full speed
		var current_speed = speed * (hurt_speed_modifier if is_hurt else 1.0)
		velocity = direction * current_speed
		move_and_slide()
		
		# Flip sprite based on direction
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
		
		# Only play run animation if not hurt or dead
		if velocity.length() > 0 and animated_sprite.animation != "run" and not is_hurt and not is_dead:
			animated_sprite.play("run")
	elif not player:
		velocity = Vector2.ZERO
		if animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

func attack():
	print("test")
	is_attacking = true
	has_hit = false
	velocity = Vector2.ZERO
	if animated_sprite.sprite_frames.has_animation("attack"):
		animated_sprite.play("attack")
		await get_tree().create_timer(0.4).timeout
		check_hit()
		await animated_sprite.animation_finished
	else:
		print("Error: 'attack' animation not found in AnimatedSprite2D")
		await get_tree().create_timer(0.5).timeout
	is_attacking = false

func check_hit():
	if player and global_position.distance_to(player.global_position) <= attack_distance and not has_hit:
		if player.has_method("take_damage"):
			player.take_damage(damage)
			has_hit = true

func take_damage(amount: int):
	health -= amount
	if animated_sprite.sprite_frames.has_animation("Hit"):
		is_hurt = true
		animated_sprite.play("Hit")
		await animated_sprite.animation_finished
		is_hurt = false
	else:
		print("Error: 'Hit' animation not found in AnimatedSprite2D")
	if health <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	if animated_sprite.sprite_frames.has_animation("Death"):
		animated_sprite.play("Death")
		$CollisionShape2D.disabled = true
		$CollisionPolygon2D.disabled = true
		await animated_sprite.animation_finished
		score +=1
		print(score)
		queue_free()
	else:
		print("Error: 'Death' animation not found in AnimatedSprite2D")
		queue_free()
	
	

func _on_area_2d_area_entered(body):
	if body == player and not is_attacking and can_attack:
		attack()
		can_attack = false
		await get_tree().create_timer(1.0).timeout
		can_attack = true
