class_name SaveData extends Resource

@export var high_score:int = 0

const SAVE_PATH:String = "user://save_data.tres"

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)
	
static func load_or_create() -> SaveData:
	var res:SaveData
	if ResourceLoader.exists(SAVE_PATH):
		res = ResourceLoader.load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res
