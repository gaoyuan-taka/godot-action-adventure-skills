extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
	},
	items = [],
	persistent = [],
	quests = [],
}


func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file = FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	pass

func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	#用open方法读取文件，如果打开文件失败，则返回 null 。而不是直接报错。

func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	GlobalLevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)

	await GlobalLevelManager.Level_load_started

	GlobalPlayerManager.set_player_postion(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	GlobalPlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	GlobalPlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)

	await GlobalLevelManager.Level_load_completed
	game_loaded.emit()
	pass

func update_player_data() -> void:
	var p: Player = GlobalPlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	pass

func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p
	pass


func update_item_data() -> void:
	current_save.items = GlobalPlayerManager.INVENTORY_DATA.get_save_data()
	pass

func add_persistent_value(value: String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistent.append(value)
	pass

func check_persistent_value(value: String) -> bool:
	var p = current_save.persistent as Array # 从current_save取出persistent字段，并以数组形式返回
	return p.has(value) # 检查传入的value是否在数组中，返回true或false