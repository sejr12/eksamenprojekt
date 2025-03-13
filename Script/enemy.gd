extends CharacterBody2D
@onready var area_signal = Callable(self, "_on_area_entered")
@export var health: int = 100  
var speed = 55
var player = null
var attacking = false  

func _ready():
	player = get_tree().get_first_node_in_group("player")  
	print(player)
	
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	$Area2D.body_exited.connect(_on_Area2D_body_exited)  

func _physics_process(_delta):
	if player and not attacking:  
		var direction = (player.position - position).normalized()  
		velocity = direction * speed
		$AnimatedSprite2D.flip_h = player.position.x < position.x
		move_and_slide()

		

func _on_Area2D_body_entered(_body):
	if _body.name == "Player":  
		attacking = true  
		attack()

func attack():
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished  
	attacking = false  

func _on_Area2D_body_exited(_body):
	if _body.name == "Player":
		attacking = false  



  

	
	
	if health <= 0:
		die()

func die() -> void:
	$AnimatedSprite2D.play("Die")
	await get_tree().create_timer(4).timeout
	queue_free()  
