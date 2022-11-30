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
	var _name = get_new_name()
		
	_new_player.set_name(_name)
	_new_player.lives = Globals.max_player_lives
	owner.add_new_player(_new_player)

func get_new_name() -> String:
	var _name = owner.n_InputNameLabels[0].get_text() + owner.n_InputNameLabels[1].get_text() + owner.n_InputNameLabels[2].get_text()
	return _name
	
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
		
		if check_name_warning():
			AudioManager.play(AudioManager.UI_ERROR)
			return
			
		var _name = get_new_name()
		
		if owner.check_player_exists(_name):
			show_name_warning(true)
			return
		else:
			show_name_warning(false)
		
		owner.set_state(Global.MENU_STATE.GAME_LIST_EXPAND)
		AudioManager.play(AudioManager.UI_COMPLETE)
	
	if !event.is_pressed():
		var _name = get_new_name()
		
		if owner.check_player_exists(_name):
			if !check_name_warning():
				show_name_warning(true)
		else:
			show_name_warning(false)

func check_name_warning() -> bool:
	return owner.n_PlayerNameWarning.visible
	
func show_name_warning(_show : bool) -> void:
	owner.n_PlayerNameWarning.visible = _show
	
	if _show:
		AudioManager.play(AudioManager.UI_ERROR)
