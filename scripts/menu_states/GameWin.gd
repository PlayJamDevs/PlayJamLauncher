extends MenuState

var _score_counter := 0

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.GAME_WIN

func enter_state(meta := {}) -> void:
	_score_counter = 0
	
	_anim_p = owner.n_AnimationPlayer
	_anim_p.connect("animation_started", self, "_on_animation_started")
	_anim_p.connect("animation_finished", self, "_on_animation_finished")
	_anim_p.play("scored")
	
	AudioManager.play(AudioManager.UI_LOSE)

func exit_state() -> void:
	_anim_p.disconnect("animation_finished", self, "_on_animation_finished")
	
func input(event) -> void:
	pass

func process(delta) -> void:
	_score_counter = clamp(_score_counter + 50, 0, Globals.SCORE_PRIZE)
	owner.n_LabelPlayerInfo.text = "GANASTE +{0} PUNTOS!".format({0:_score_counter})

func _on_animation_started(anim_name : String) -> void:
	Globals.emit_signal("update_player_scores")	
	
func _on_animation_finished(anim_name : String) -> void:	
	owner.set_state(Globals.MENU_STATE.GAME_EXECUTE, {})
