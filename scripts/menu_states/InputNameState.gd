extends MenuState

const PlayerScore := preload("res://scenes/PlayerScore/PlayerScore.tscn")

var _selected_index := 0
var _input_name_idx := 0
var _input_letter := 0

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.INPUT_NAME

func enter_state(meta := {}) -> void:
	_selected_index = 0
	_input_name_idx = 0
	_input_letter = 0
	
	_anim_p = owner.n_AnimationPlayer
	_anim_p.play("input_name")

func exit_state() -> void:
	var _new_player = PlayerScore.instance()
	var _name = owner.n_InputNameLabels[0].get_text() + owner.n_InputNameLabels[1].get_text() + owner.n_InputNameLabels[2].get_text()
	
	_new_player.set_name(_name)
	_new_player.lives = Globals.max_player_lives
	owner.add_new_player(_new_player)

func input(event : InputEvent) -> void:	
	if Input.is_action_just_pressed("ui_left"):
		owner.n_InputNameLabels[_input_name_idx].deselect()
		_input_name_idx = wrapi(_input_name_idx - 1, 0, 3)
		owner.n_InputNameLabels[_input_name_idx].select()
		AudioManager.play(AudioManager.UI_BEEP)
	elif Input.is_action_just_pressed("ui_right"):
		owner.n_InputNameLabels[_input_name_idx].deselect()
		_input_name_idx = wrapi(_input_name_idx + 1, 0, 3)
		owner.n_InputNameLabels[_input_name_idx].select()
		AudioManager.play(AudioManager.UI_BEEP)
	elif Input.is_action_just_pressed("ui_up"):
		owner.n_InputNameLabels[_input_name_idx]._scancode += 1
		AudioManager.play(AudioManager.UI_BEEP, 1.02)
	elif Input.is_action_just_pressed("ui_down"):
		owner.n_InputNameLabels[_input_name_idx]._scancode -= 1
		AudioManager.play(AudioManager.UI_BEEP, 1.01)
	elif Input.is_action_just_pressed("ui_accept"):
		owner.set_state(Global.MENU_STATE.GAME_LIST_EXPAND)
		AudioManager.play(AudioManager.UI_COMPLETE)
