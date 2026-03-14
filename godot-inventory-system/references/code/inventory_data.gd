class_name InventoryData extends Resource
#道具栏、背包

@export var slots: Array[SlotData]


func _init() -> void:
	if slots != null and slots.size() > 0:
		connect_slots()
	pass

func add_item(item: ItemData, count: int = 1) -> bool:
	for s in slots: # 当拾取的物品已存在于背包的情况
		if s != null:
			if s.item_data == item: # 如果物品已存在于背包
				s.quantity += count
				return true

	 # 当拾取的物品不存在于背包的情况	
	for i in slots.size(): # 会逐个返回数组中每个元素的编号
		if slots[i] == null:
			var new = SlotData.new() # new()是创建一个新的实例，把soltdata类实体化
			new.item_data = item
			new.quantity = count
			slots[i] = new
			new.changed.connect(slot_changed)
			return true
			
	print("背包已满") # 如果以上两条都不满足
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)


func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity <= 0:
				s.changed.disconnect(slot_changed)
				var index = slots.find(s) # 找到当前物品在数组（物品栏）中的位置
				slots[index] = null
				changed.emit()
	pass


func get_save_data() -> Array:
	var item_save: Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save


func item_to_save(slot: SlotData) -> Dictionary:
	var result = {item = "", quantity = 0}
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_save_data(save_data: Array) -> void:
	var array_size = slots.size()
	slots.clear() # 清空槽位，会让数组的尺寸也清空。
	slots.resize(array_size) # 因此需要重新设置数组的尺寸。
	for i in save_data.size():
		slots[i] = item_from_save(save_data[i])
	connect_slots() # 因为加载存档时候，_init()不会被调用，所以需要手动重新连接信号。
	pass

func item_from_save(save_object: Dictionary) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot: SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int(save_object.quantity)
	return new_slot

func use_item(item: ItemData, count: int = 1) -> bool:
	for s in slots:
		if s:
			if s.item_data == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false
