extends MenuState

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.INTRO

func input(event) -> void:
	if owner.n_WarningDialog.visible:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		owner.set_state(Globals.MENU_STATE.INPUT_NAME)
		AudioManager.play(AudioManager.UI_INTRO)
