extends CanvasLayer

@export var button_focus_audio: AudioStream = preload("res://Title Scene/Audio/menu_focus.wav")
@export var button_select_audio: AudioStream = preload("res://Title Scene/Audio/menu_select.wav")

@onready var game_over: Control = $Control/GameOVer
@onready var continue_button: Button = $Control/GameOVer/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOVer/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOVer/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


var hearts: Array[HeartGUI] = []

func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false

	hide_game_over_screen()
	continue_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	continue_button.pressed.connect(load_game)
	title_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	title_button.pressed.connect(title_screen)
	GlobalLevelManager.Level_load_started.connect(hide_game_over_screen)


func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)
	pass


func update_heart(_index: int, _hp: int) -> void: # 计算每颗心的显示状态
	var _value: int = clamp(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_hp(_max_hp: int) -> void: # 计算角色总血量->总心数量
	var _heart_count: int = roundi(_max_hp / 2)
	for i in hearts.size(): # 拿到所有心的索引
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass


func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP

	var can_continue: bool = GlobalSaveManager.get_save_file() != null
	continue_button.visible = can_continue

	animation_player.play("show_game_over")
	await animation_player.animation_finished

	if can_continue:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()

	pass

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1, 1, 1, 0)
	pass

func load_game() -> void:
	play_audio(button_select_audio)
	await fade_to_back()
	GlobalSaveManager.load_game()
	pass

func title_screen() -> void:
	play_audio(button_select_audio)
	await fade_to_back()
	GlobalLevelManager.load_new_level("res://Title Scene/title_scene.tscn", "", Vector2.ZERO)
	
	pass

func fade_to_back() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	GlobalPlayerManager.player.revive_player()
	return true

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()
