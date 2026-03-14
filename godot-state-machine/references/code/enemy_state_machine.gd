class_name EnemyStateMachine extends Node
## EnemyStateMachine - 敌人状态机管理器
## 负责管理敌人状态的切换和生命周期调用
##
## 使用方法：
## 1. 将此脚本附加到敌人节点下的 StateMachine 节点
## 2. 在 StateMachine 下添加各个状态节点（继承 EnemyState）
## 3. 在敌人 _ready() 中调用 state_machine.initialize(self)

var states: Array = [EnemyState]
var current_state: EnemyState
var prev_state: EnemyState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass


func _physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))
	pass


func initialize(_enemy: Enemy) -> void:
	states = []

	for c in get_children():
		if c is EnemyState:
			states.append(c)

	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()

	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
	
	pass


func change_state(new_state: EnemyState) -> void:
	if new_state == current_state || new_state == null:
		return
	
	# 场景初次运行时，current_state 为空，不需要执行 exit
	if current_state:
		current_state.exit()

	prev_state = current_state
	current_state = new_state
	current_state.enter()
