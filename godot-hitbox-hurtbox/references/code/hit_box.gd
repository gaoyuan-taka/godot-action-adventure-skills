class_name HitBox extends Area2D
## HitBox - 攻击区域
## 附加到攻击源（武器、技能特效等）
## 
## 配置说明：
## - collision_layer: 0（不被检测）
## - collision_mask: 设置为要攻击的目标层
## - monitorable: false
## 
## 使用方法：
## 1. 实例化此场景作为子节点
## 2. 添加 CollisionShape2D 定义攻击范围
## 3. 设置 damage 属性定义伤害值
## 4. 可选：连接 hit_landed 信号实现攻击反馈

signal hit_landed # 命中目标时发出

@export var damage: int = 1 # 攻击伤害值


func _ready() -> void:
	area_entered.connect(_area_entered)
	pass


func _process(_delta: float) -> void:
	pass


func _area_entered(area: Area2D) -> void:
	if area is HurtBox:
		hit_landed.emit()
		area.take_damage(self)
	pass
