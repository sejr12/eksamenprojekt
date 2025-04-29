extends Area2D

var speed: float = 0.0
var damage: float = 0.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_collision_layer_value(1, true) 
	set_collision_mask_value(2, true)
	connect("body_entered", _on_body_entered)

func set_velocity(projectile_speed: float, projectile_damage: float) -> void:
	speed = projectile_speed
	damage = projectile_damage
	velocity = Vector2(cos(rotation), sin(rotation)) * speed

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  

func _on_screen_exited() -> void:
	queue_free() 
