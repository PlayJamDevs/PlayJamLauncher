extends Node

const UI_INTRO := preload("res://assets/sfx/ui_intro.wav")
const UI_SELECT := preload("res://assets/sfx/ui_select.wav")
const UI_CANCEL := preload("res://assets/sfx/ui_cancel.wav")
const UI_EXECUTE := preload("res://assets/sfx/ui_execute.wav")
const UI_BEEP := preload("res://assets/sfx/ui_beep.wav")
const UI_COMPLETE := preload("res://assets/sfx/ui_complete.wav")
const UI_ERROR := preload("res://assets/sfx/ui_error.wav")
const UI_WIN := preload("res://assets/sfx/win.wav")
const UI_LOSE := preload("res://assets/sfx/lose.wav")

onready var stream_idx := 0

func _get_next_audio_player() -> AudioStreamPlayer:
	var stream = get_child(stream_idx) as AudioStreamPlayer
	stream_idx = wrapi(stream_idx + 1, 0, get_child_count())
	return stream

func play(stream : AudioStream, pitch_scale := 1.0, volume_db := 1.0) -> void:
	if stream == null:
		return
	
	var audio_p := _get_next_audio_player()
	audio_p.stream = stream
	audio_p.volume_db = volume_db
	audio_p.pitch_scale = pitch_scale
	audio_p.play()

func play_random(stream : Array, pitch_scale := 1.0, volume_db := 1.0) -> void:
	stream.shuffle()
	play(stream.front(), pitch_scale, volume_db)
