extends Node

signal Level_load_started
signal Level_load_completed
signal TilemapBoundsChanged(bounds: Array[Vector2])

var current_tilemap_bounds: Array[Vector2]
var target_door: String
var position_offset: Vector2

func _ready() -> void:
	await get_tree().process_frame
	Level_load_completed.emit() # 首次加载时候，发送信号，level_transition中的monitoring=true
	pass


func ChangeTilemapBounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	TilemapBoundsChanged.emit(current_tilemap_bounds)
	pass

func load_new_level(level_path: String, _target_door: String, _position_offset: Vector2) -> void:
	get_tree().paused = true
	target_door = _target_door
	position_offset = _position_offset

	await SceneTransitionAnime.fade_out()

	Level_load_started.emit() # 链接到level脚本的free_level函数，清空当前场景

	await get_tree().process_frame

	get_tree().change_scene_to_file(level_path)

	await SceneTransitionAnime.fade_in()

	get_tree().paused = false
	
	Level_load_completed.emit()


	pass
