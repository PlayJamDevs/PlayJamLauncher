extends MenuState

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.GAME_LIST_EXPAND

func enter_state(meta := {}) -> void:
	_anim_p = owner.n_AnimationPlayer
	_anim_p.connect("animation_finished", self, "_animation_finished")
	
	_anim_p.play("game_list_expand")
	owner.update_player_info()

func exit_state() -> void:
	_anim_p.disconnect("animation_finished", self, "_animation_finished")

func input(event) -> void:
	pass

func _animation_finished(_anim_name) -> void:
	owner.n_ItemList.grab_focus()
	owner.n_ItemList.select(0)
	owner.set_state(Globals.MENU_STATE.GAME_SELECTION)
