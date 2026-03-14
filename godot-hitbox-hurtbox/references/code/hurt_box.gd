class_name HurtBox extends Area2D
## HurtBox - 受伤区域
## 附加到可被攻击的对象（玩家、敌人等）
## 
## 配置说明：
## - collision_layer: 设置为目标可被攻击的层
## - collision_mask: 0（不主动检测）
## - monitoring: false
## 
## 使用方法：
## 1. 实例化此场景作为子节点
## 2. 添加 CollisionShape2D 定义受伤范围
## 3. 连接 damaged 信号处理受伤逻辑

signal damaged(hit_box: HitBox) # 受到伤害时发出


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func take_damage(hit_box: HitBox) -> void:
	damaged.emit(hit_box)
