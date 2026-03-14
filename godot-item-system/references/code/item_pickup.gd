@tool
class_name ItemPickup extends CharacterBody2D

signal picked_up


@export var item_data: ItemData: set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	_update_texture() # 场景加载时候，先加载贴图
	if Engine.is_editor_hint():
		return

	area_2d.body_entered.connect(_on_body_entered)
	pass


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta) # move_and_collide移动过程中检测是否有碰撞，返回true或false
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) # get_normal()碰撞面的法线方向，法线永远 垂直于碰撞面，指向“外侧”
	velocity -= velocity * delta * 4
	pass
	

func _on_body_entered(b) -> void:
	if b is Player:
		if item_data != null:
			if GlobalPlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_picked_up()
				
	pass

func item_picked_up() -> void:
	area_2d.body_entered.disconnect(_on_body_entered) # 断开信号链接，防止物品被重复拾取
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _set_item_data(value: ItemData) -> void: # 这个函数是为了在编辑器中实时更新
	item_data = value
	_update_texture()
	pass


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass