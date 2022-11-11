class_name MenuState

var owner : Control
var _anim_p : AnimationPlayer

func _init(_owner):
	owner = _owner

func get_type() -> int:
	return -1

func enter_state(meta := {}) -> void:
	pass

func exit_state() -> void:
	pass
	
func input(event : InputEvent) -> void:
	pass

func process(delta) -> void:
	pass
