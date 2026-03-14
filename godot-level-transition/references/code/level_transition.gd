@tool # 让脚本可以在编辑器里运行，而不用启动游戏
class_name LevelTransition extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file("*.tscn") var Level
@export var target_door: String
@export var center_player: bool = false

@export_category("Collision Area Settings")

@export_range(1, 12, 1, "or_greater") var size: int = 2:
	set(_v):
		size = _v
		_update_area()
	
@export var side: SIDE = SIDE.LEFT:
	set(_v):
		side = _v
		_update_area()
	
@export var snap_to_grid: bool = false:
	set(_v):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return

	monitoring = false # 防止角色进入传送区后，陷入传送死循环。所以在场景加载后，先将接触开关关掉。
	_place_player()

	await GlobalLevelManager.Level_load_completed
	await get_tree().create_timer(0.5).timeout
	monitoring = true

	body_entered.connect(_player_entered)

	pass

func _player_entered(_p: Node2D) -> void:
	GlobalLevelManager.load_new_level(Level, target_door, get_offset())
	pass

func _place_player() -> void:
	if name != GlobalLevelManager.target_door:
		return
	GlobalPlayerManager.set_player_postion(global_position + GlobalLevelManager.position_offset)
	pass

func get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_position: Vector2 = GlobalPlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_position.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_position.x - global_position.x
		offset.y = 16
		if side == SIDE.TOP:
			offset.y *= -1
	return offset

func _update_area() -> void:
	var new_rect: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO

	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16

	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")

	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
	pass

func _snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16
	pass
