extends Sprite2D

var _smoothed_mouse_pos: Vector2

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
