extends Node2D

@export var enemy_scene: PackedScene  
@export var spawn_area: Rect2 = Rect2(0, 0, 800, 600) 
@export var wave_interval: float = 5 
@export var enemies_per_wave: int = 5  
@export var wave_enemy_increment: int = 2 
@export var max_waves: int = 10  

var current_wave: int = 0
var enemies_alive: int = 0
var wave_active: bool = false

func _ready():
	await get_tree().create_timer(2.0).timeout
	start_next_wave()

func start_next_wave():
	if current_wave >= max_waves:
		print("All waves completed!")
		return

	current_wave += 1
	var enemies_to_spawn = enemies_per_wave + (wave_enemy_increment * (current_wave - 1))
	print("Starting Wave ", current_wave, " with ", enemies_to_spawn, " enemies")

	for i in range(enemies_to_spawn):
		spawn_enemy()
		await get_tree().create_timer(0.5).timeout

	wave_active = true

func spawn_enemy():
	if not enemy_scene:
		push_error("Enemy scene is not assigned in EnemySpawner! Please set the 'Enemy Scene' property in the editor.")
		return
	var enemy_instance = enemy_scene.instantiate()
	var spawn_position = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	enemy_instance.global_position = spawn_position
	get_tree().current_scene.add_child(enemy_instance)
	enemy_instance.connect("tree_exited", Callable(self, "_on_enemy_died"))
	enemies_alive += 1

func _on_enemy_died():
	if not is_inside_tree():
		return
	enemies_alive -= 1
	Global.score += 1
	var main = get_tree().current_scene
	if main and main.has_method("update_score"):
		main.update_score()
	if wave_active and enemies_alive <= 0:
		wave_active = false
		if is_inside_tree():
			await get_tree().create_timer(wave_interval).timeout
			if is_inside_tree():
				start_next_wave()


func _process(_delta):
	pass
