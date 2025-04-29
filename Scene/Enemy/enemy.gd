extends CharacterBody2D

@export var speed = 200.0
@export var attack_distance = 150.0
@export var damage = 25
@export var health: int = 50
@export var hurt_speed_modifier = 0.8

@onready var player = Global.player
@onready var animated_sprite = $AnimatedSprite2D
var is_attacking = false
var is_hurt = false
var is_dead = false
var can_attack = true
var has_hit = false
var score = 0
var player_in_range = false

func _ready():
	if not player:
		print("global.player er null", global_position)

func _physics_process(_delta):
	if is_dead:  
		return
	
	if player:
		if not is_attacking:
			var direction = (player.global_position - global_position).normalized()
			var current_speed = speed * (hurt_speed_modifier if is_hurt else 1.0)
			velocity = direction * current_speed
			move_and_slide()
			
			if direction.x > 0:
				animated_sprite.flip_h = false
			elif direction.x < 0:
				animated_sprite.flip_h = true
			
			if velocity.length() > 0 and animated_sprite.animation != "run" and not is_hurt:
				animated_sprite.play("run")
		
		if player_in_range and not is_attacking and can_attack:
			attack()
			can_attack = false
			await get_tree().create_timer(1.0).timeout
			can_attack = true
	else:
		velocity = Vector2.ZERO
		if animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

func attack():
	is_attacking = true
	has_hit = false
	velocity = Vector2.ZERO
	if animated_sprite.sprite_frames.has_animation("attack"):
		animated_sprite.play("attack")
		await get_tree().create_timer(0.4).timeout
		check_hit()
		await animated_sprite.animation_finished
	else:
		print("ingen attack animation")
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
		print("ingen hit animation")
	if health <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	print("Enemy died, checking for Death animation...")
	print("Available animations: ", animated_sprite.sprite_frames.get_animation_names())
	if animated_sprite.sprite_frames.has_animation("Death"):
		print("Playing Death animation")
		animated_sprite.play("Death")
		$CollisionShape2D.disabled = true
		$CollisionPolygon2D.disabled = true
		await animated_sprite.animation_finished
		score += 1
		print("Death animation finished, score: ", score)
		queue_free()
	else:
		print("ingen death animation")
		queue_free()

func _on_area_2d_body_entered(body):
	print("Area2D body entered by: ", body)
	if body == player:
		player_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Area2D body exited by: ", body)
	if body == player:
		player_in_range = false
