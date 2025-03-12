extends Node2D

@onready var area_2d: Area2D = $Area2D

const speed = 1500
@export var damage: int = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed  * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()




func _on_area_entered(area: Area2D) -> void:
	print("Bullet hit:", area.name)  # Debugging

	if area.is_in_group("enemies"):  # Ensure enemy is in the right group
		var enemy = area.get_parent()  # Get the enemy node
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)  # Deal damage
		queue_free()  # Destroy the bullet
