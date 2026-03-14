class_name PlayerStateMachine extends Node
## PlayerStateMachine - 玩家状态机管理器
## 负责管理玩家状态的切换和生命周期调用
##
## 使用方法：
## 1. 将此脚本附加到玩家节点下的 StateMachine 节点
## 2. 在 StateMachine 下添加各个状态节点（继承 State）
## 3. 在玩家 _ready() 中调用 state_machine.initialize(self)

var states: Array = [State]
var current_state: State
var prev_state: State
var next_state: State


func _ready() -> void:
	# 禁用处理直到初始化完成，防止状态机先于玩家初始化
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	pass


func _physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))
	pass


func initialize(_player: Player) -> void:
	states = []

	# 收集所有 State 子节点
	for c in get_children():
		if c is State:
			states.append(c)

	if states.size() == 0:
		return

	# 设置静态引用（所有状态共享）
	states[0].player = _player
	states[0].state_machine = self
	
	# 初始化所有状态
	for state in states:
		state.init()
	
	# 切换到第一个状态
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

	pass


func change_state(new_state: State) -> void:
	if new_state == current_state || new_state == null:
		return
	
	next_state = new_state

	if current_state:
		current_state.exit()

	prev_state = current_state
	current_state = new_state
	current_state.enter()
