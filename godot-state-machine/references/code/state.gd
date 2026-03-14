class_name State extends Node
## State - 玩家状态基类
## 定义状态生命周期方法，所有玩家状态继承此类
##
## 生命周期：
## - init(): 状态机初始化时调用一次
## - enter(): 每次进入该状态时调用
## - exit(): 每次离开该状态时调用
## - process(delta): 每帧 _process 中调用
## - physics_process(delta): 每帧 _physics_process 中调用
## - handle_input(event): 每次 _unhandled_input 时调用
##
## 使用静态变量共享 player 和 state_machine 引用

static var player: Player # 静态变量的实例会被所有脚本共享
static var state_machine: PlayerStateMachine


func _ready() -> void:
	pass


func init() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
	# 返回 null 保持当前状态
	# 返回其他 State 实例则切换状态
	return null


func physics_process(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
