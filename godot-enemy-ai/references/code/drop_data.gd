class_name DropData extends Resource

@export var item: ItemData
@export_range(1, 100, 1, "suffix:%") var probability: float = 100
@export_range(1, 10, 1, "suffix:items") var max_quantity: int = 1
@export_range(1, 10, 1, "suffix:items") var min_quantity: int = 1


func get_drop_count() -> int:
    if randf_range(1, 100) >= probability:
        return 0
    return randi_range(min_quantity, max_quantity)