extends Node

var player: Node = null
var score = 0
var save_data:SaveData
var last_score = 0

func _ready():
	save_data = SaveData.load_or_create()
	print("sigma")
