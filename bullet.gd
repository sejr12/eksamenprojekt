extends Area2D

var speed: float = 0.0
var damage: float = 0.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Ensure the bullet is set to collide with enemies
	set_collision_layer_value(1, true)  # Bullet layer
	set_collision_mask_value(2, true)   # Collide with enemy layer
	connect("body_entered", _on_body_entered)

func set_velocity(projectile_speed: float, projectile_damage: float) -> void:
	# Called by PistolScript to set speed and damage
	speed = projectile_speed
	damage = projectile_damage
	velocity = Vector2(cos(rotation), sin(rotation)) * speed

func _physics_process(delta: float) -> void:
	# Move the bullet
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	# Check if the collided body is an enemy
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # Destroy bullet on impact

func _on_screen_exited() -> void:
	queue_free()  # Destroy bullet when it leaves the screen
