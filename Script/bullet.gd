extends Node2D

@export var speed: float = 500.0
var direction = Vector2.ZERO

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)  # Convert rotation to movement direction

func _process(delta):
	position += direction * speed * delta
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


	
