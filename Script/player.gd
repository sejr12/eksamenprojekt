extends CharacterBody2D

@onready var head: AnimatedSprite2D = $head




signal health_updated(health)  # Signal to send health updates
signal stamina_updated(stamina)

const BASE_SPEED = 500
var speed = BASE_SPEED
const MAX_HEALTH = 100
var health = MAX_HEALTH 
const STRAFE_SPEED_MULTIPLIER = 0.5
const MAX_STAMINA = 100
var current_stamina = MAX_STAMINA 
const STAMINA_DEPLETION_RATE = 50  
const STAMINA_REGEN_RATE = 50  
const STAMINA_REGEN_DELAY = 5.0
const ROTATION_SPEED = 10.0
var is_sprinting = false
var stamina_regen_timer = 0.0
func _ready():
	Global.player = self
	
	
func _physics_process(delta):

	if Input.is_action_pressed("move_right"):  # D key
		head.flip_h = false
		head.play("Walk")
	elif Input.is_action_pressed("move_down"):  # S key
		head.play("Walk")
	elif Input.is_action_pressed("move_up"):  # W key
		head.play("Walk")
	elif Input.is_action_pressed("move_left"):  # A key
		head.flip_h = true
		head.play("Walk")
	velocity = Vector2()  # Reset velocity

	# Sprint logic
	if Input.is_action_pressed("sprint") and current_stamina > 0:
		speed = BASE_SPEED * 2  # Double the speed
		is_sprinting = true
		current_stamina -= STAMINA_DEPLETION_RATE * delta  # Decrease stamina while sprinting
		stamina_regen_timer = 0.0  # Reset stamina regen delay
	else:
		is_sprinting = false
		speed = BASE_SPEED  # Reset to normal speed

		# Start stamina regen timer
		if current_stamina < MAX_STAMINA:
			stamina_regen_timer += delta
			if stamina_regen_timer >= STAMINA_REGEN_DELAY:
				current_stamina += STAMINA_REGEN_RATE * delta  # Refill stamina

	# Clamp stamina to valid range
	current_stamina = clamp(current_stamina, 0, MAX_STAMINA)
	stamina_updated.emit(current_stamina)

	# **Movement based on specific keys (no rotation)**:
	if Input.is_action_pressed("move_up"): 
		velocity.y -= speed  # Move up
	if Input.is_action_pressed("move_down"): 
		velocity.y += speed  # Move down
	if Input.is_action_pressed("move_left"):    
		velocity.x -= speed  # Move left
	if Input.is_action_pressed("move_right"):  
		velocity.x += speed  # Move right

	move_and_slide()



func take_damage(amount):
	health -= amount
	health_updated.emit(health)
	print("Player Health: ", health)
	
	if health <= 0:
		game_over()

func heal(amount):
	health = min(health + amount, MAX_HEALTH)
	health_updated.emit(health)
	print("Player Healed: ", health)

func game_over():
	get_tree().change_scene_to_file("res://Scene/tempdeathscreen.tscn")
