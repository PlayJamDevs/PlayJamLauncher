extends MenuState

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.GAME_LOSE

func enter_state(meta := {}) -> void:
	_anim_p = owner.n_AnimationPlayer
	_anim_p.connect("animation_started", self, "_on_animation_started")
	_anim_p.connect("animation_finished", self, "_on_animation_finished")
	_anim_p.play("lost_life")
	
	var _lives := Globals.current_player.lives
	
	if _lives > 0:
		owner.n_LabelPlayerInfo.text = "TE {0} {1} {2}".format({0:"QUEDAN" if _lives != 1 else "QUEDA",1:_lives,2:"VIDAS" if _lives != 1 else "VIDA"})
	else:
		owner.n_LabelPlayerInfo.text = "GAME OVER!"
	
	AudioManager.play(AudioManager.UI_LOSE)

func exit_state() -> void:
	_anim_p.disconnect("animation_started", self, "_on_animation_started")
	_anim_p.disconnect("animation_finished", self, "_on_animation_finished")
#	var signals = _anim_p.get_signal_list()
#
#	for current_signal in signals:
#	    var connections = _anim_p.get_signal_connection_list(current_signal.name);
#	    for conn in connections:
#	       _anim_p.disconnect(conn.signal, self, conn.method)
	
func input(event) -> void:
	pass

func process(delta) -> void:
	pass

func _on_animation_started(anim_name : String) -> void:
	Globals.emit_signal("player_lost_life")

func _on_animation_finished(anim_name : String) -> void:
	if Globals.current_player.lives == 0:
		owner.set_state(Globals.MENU_STATE.INPUT_NAME, {})
		return
		
	owner.set_state(Globals.MENU_STATE.GAME_EXECUTE, {})
