extends RigidBody2D

var speed = 500
var direction = Vector2.ZERO

func _ready():
	linear_velocity = direction * speed  

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
