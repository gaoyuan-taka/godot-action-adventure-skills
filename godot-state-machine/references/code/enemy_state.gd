class_name EnemyState extends Node
## EnemyState - 敌人状态基类
## 定义敌人状态生命周期方法
##
## 与 State 的区别：
## - 使用实例变量而非静态变量
## - 没有 handle_input 方法（敌人不处理玩家输入）

var enemy: Enemy
var state_machine: EnemyStateMachine


func init() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	return null


func physics_process(_delta: float) -> EnemyState:
	return null
