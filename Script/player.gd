extends CharacterBody2D

@onready var head: AnimatedSprite2D = $head




signal health_updated(health)  
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

	if Input.is_action_pressed("move_right"):  
		head.flip_h = false
		head.play("Walk")
	elif Input.is_action_pressed("move_down"): 
		head.play("Walk")
	elif Input.is_action_pressed("move_up"): 
		head.play("Walk")
	elif Input.is_action_pressed("move_left"): 
		head.flip_h = true
		head.play("Walk")
	velocity = Vector2()  

	
	if Input.is_action_pressed("sprint") and current_stamina > 0:
		speed = BASE_SPEED * 2  
		is_sprinting = true
		current_stamina -= STAMINA_DEPLETION_RATE * delta  
		stamina_regen_timer = 0.0  
	else:
		is_sprinting = false
		speed = BASE_SPEED  

		
		if current_stamina < MAX_STAMINA:
			stamina_regen_timer += delta
			if stamina_regen_timer >= STAMINA_REGEN_DELAY:
				current_stamina += STAMINA_REGEN_RATE * delta  

	
	current_stamina = clamp(current_stamina, 0, MAX_STAMINA)
	stamina_updated.emit(current_stamina)

	
	if Input.is_action_pressed("move_up"): 
		velocity.y -= speed 
	if Input.is_action_pressed("move_down"): 
		velocity.y += speed  
	if Input.is_action_pressed("move_left"):    
		velocity.x -= speed  
	if Input.is_action_pressed("move_right"):  
		velocity.x += speed  

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
	if Global.score > Global.save_data.high_score:
		Global.save_data.high_score = Global.score
		Global.save_data.save()

	Global.last_score = Global.score 
	Global.score = 0 

	get_tree().change_scene_to_file("res://Scene/tempdeathscreen.tscn")
