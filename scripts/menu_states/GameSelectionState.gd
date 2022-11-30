extends MenuState

var _item_list : ItemList
var _thumbnail : TextureRect
var _selected_index := 0

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.GAME_SELECTION

func enter_state(meta := {}) -> void:
	_anim_p = owner.n_AnimationPlayer
	_anim_p.play("game_list_expanded")
	
	_item_list = owner.n_ItemList
	_thumbnail = owner.n_ThumbnailTexture
	
	_selected_index = 0
	
	if !owner.n_MusicPlayer.playing:
		owner.n_MusicPlayer.play()	
		
	owner.n_ItemList.select(_selected_index)
	
	owner._sort_scores()
	_get_selected_thumbnail()
	
	
func input(event) -> void:
	if _item_list.get_item_count() == 0:
		return
		
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.doubleclick):
		AudioManager.play(AudioManager.UI_EXECUTE)
		owner.set_state(Globals.MENU_STATE.GAME_EXECUTE, {
			Globals.METADATA.GAME_INDEX: _selected_index
		})
		return
	
#	if Input.is_action_pressed("ui_cancel"):
#		AudioManager.play(AudioManager.UI_CANCEL)
#		owner.set_state(Globals.MENU_STATE.INPUT_NAME)
#		return
	
	if Input.is_action_just_released("ui_up"):
		_selected_index -= 1
		AudioManager.play(AudioManager.UI_SELECT)
	elif Input.is_action_just_released("ui_down"):
		_selected_index += 1
		AudioManager.play(AudioManager.UI_SELECT)
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
		
		if !_item_list.get_rect().has_point(event.position):
			return
			
		_selected_index = _item_list.get_item_at_position(event.position)
		AudioManager.play(AudioManager.UI_SELECT)
	
	_selected_index = wrapi(_selected_index, 0, _item_list.get_item_count())
	_item_list.select(_selected_index)
#	_selected_index = clamp(_selected_index, 0, _item_list.get_item_count() - 1)

	_get_selected_thumbnail()
	
func _get_selected_thumbnail() -> void:
	var _meta = _item_list.get_item_metadata(_selected_index)
	var _thumbnail_path = _meta[Global.GAME_METADATA.PATH] + "/cover.png"
	var image := Image.new()
	image.load(_thumbnail_path)
	var t := ImageTexture.new()
	t.create_from_image(image)
	_thumbnail.texture = t
	owner.n_ThumbnailTexture.visible = true
	
