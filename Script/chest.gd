extends Node2D

@onready var area = $Area2D
@onready var item_area = $ItemSprite/Area2D
@onready var item_sprite = $ItemSprite/Area2D
@onready var chest_sprite = $AnimatedSprite2D

var is_opened = false

func _ready():
	area.body_entered.connect(_on_Area2D_body_entered)
	item_area.body_entered.connect(_on_ItemArea2D_body_entered)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and not is_opened:
		is_opened = true
		print("Chest opened!")
		if chest_sprite:
			chest_sprite.play("Open")
			item_sprite.visible = true
			item_area.monitoring = true

func _on_ItemArea2D_body_entered(body):
	if body.is_in_group("player"):
		print("Item picked up!")
		item_sprite.queue_free()
		item_area.queue_free()
