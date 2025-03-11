extends Node2D

@onready var area = $Area2D  # Sørg for, at du har en Area2D som barn af kisten
@onready var item_sprite = $ItemSprite
@onready var chest_sprite = $AnimatedSprite2D

var is_opened = false  # For at sikre, at kisten kun åbnes én gang

func _ready():
	area.body_entered.connect(_on_Area2D_body_entered)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not is_opened:
		is_opened = true  # Undgå at åbne flere gange
		print("Chest opened!")
		if chest_sprite:
			chest_sprite.play("Open")
			await get_tree().create_timer(0.5).timeout
			item_sprite.visible = true
		await get_tree().create_timer(10).timeout
		queue_free()
