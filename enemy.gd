extends CharacterBody2D

var health = 100
var speed = 55
var player = null
var attacking = false  

func _ready():
	player = get_node("/root/Main/Player") 
	print(player)
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	$Area2D.body_exited.connect(_on_Area2D_body_exited)  # Detect when player leaves attack range

func _physics_process(_delta):
	if player and not attacking:  # Move only if not attacking
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("run")

		# Flip sprite based on direction
		$AnimatedSprite2D.flip_h = player.position.x < position.x

func _on_Area2D_body_entered(_body):
	if _body.name == "Player":  # Ensure enemy detects the player
		attacking = true  # Start attack
		attack()

func attack():
	while attacking:  # Keep attacking as long as the player is inside Area2D
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished  # Wait for attack to finish

func _on_Area2D_body_exited(_body):
	if _body.name == "Player":
		attacking = false  # Stop attacking when player leaves
