class_name InventoryUI extends Control


const INVENTORY_SOLT = preload("uid://b4jfbssngoi7r") # 道具槽

@export var data: InventoryData

var focus_index: int = 0


func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory() # 加载场景时，清空在godot菜单中用于站位的道具槽
	data.changed.connect(on_inventory_changed)
	pass


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory(i: int = 0) -> void:
	clear_inventory()
	await get_tree().process_frame # 等待一帧，确保clear_inventory()执行，所有道具槽都被清空
	for s in data.slots:
		var new_slot = INVENTORY_SOLT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
	await get_tree().process_frame
	get_child(i).grab_focus() # 当物品用完后，强制聚焦到已经空的槽


func item_focused() -> void: # 修复物品用光后，选择框失焦的bug
	for i in get_child_count():
		if get_child(i).has_focus(): # 返回当前选中物品栏的编号
			focus_index = i
			return
pass


func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory(i)
pass
