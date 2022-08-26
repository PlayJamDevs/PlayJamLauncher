class_name Main extends Control

onready var n_AnimationPlayer := $AnimationPlayer
onready var n_MusicPlayer := $AudioStreamPlayer

onready var n_SidePanel := $MarginContainer/SidePanelControl
onready var n_ItemList := $MarginContainer/SidePanelControl/MarginContainer/ItemList
onready var n_ThumbnailTexture := $GameThumbnail

onready var n_PressStartContainer := $PressStartContainer

onready var n_LabelPlayerName := $PlayerDataContainer/VBoxContainer/LabelPlayerName
onready var n_LabelPlayerLives := $PlayerDataContainer/VBoxContainer/LabelPlayerLives

onready var n_PlayerNameInput := $CanvasLayer/Control/CCPlayerName
onready var n_InputNameLabels := [
	$CanvasLayer/Control/CCPlayerName/VBox/CC/GC/LetterInput1,
	$CanvasLayer/Control/CCPlayerName/VBox/CC/GC/LetterInput2,
	$CanvasLayer/Control/CCPlayerName/VBox/CC/GC/LetterInput3
]

onready var n_WarningDialog := $CanvasLayer/Control/PopUpControl/AcceptDialog
onready var n_PlayerScoresList := $CanvasLayer/Control/ScoreBoardContainer/VBoxContainer2/VScrollBar/VBoxPlayerScore
onready var n_LabelPlayerInfo := $CanvasLayer/Control/CenterContainer/LabelPlayerInfo

onready var MenuStates := {
	Global.MENU_STATE.INTRO: preload("res://scripts/menu_states/IntroState.gd").new(self),
	Global.MENU_STATE.INPUT_NAME: preload("res://scripts/menu_states/InputNameState.gd").new(self),
	Global.MENU_STATE.GAME_LIST_EXPAND: preload("res://scripts/menu_states/GameListExpand.gd").new(self),
	Global.MENU_STATE.GAME_SELECTION: preload("res://scripts/menu_states/GameSelectionState.gd").new(self),
	Global.MENU_STATE.GAME_EXECUTE: preload("res://scripts/menu_states/GameExecute.gd").new(self),
	Global.MENU_STATE.GAME_LOSE: preload("res://scripts/menu_states/GameLose.gd").new(self),
	Global.MENU_STATE.GAME_WIN: preload("res://scripts/menu_states/GameWin.gd").new(self),
}

onready var current_state = MenuStates.get(Global.MENU_STATE.INTRO)

var config := ConfigFile.new()

func _ready():
	randomize()
	
	var _err = config.load(Globals.CONFIG_FILENAME)
	
	if _err != OK:
		save_settings()
	else:
		Globals.play_mode = config.get_value("Globals","play_mode", Globals.play_mode)
		Globals.max_player_lives = config.get_value("Globals","player_lives", Globals.max_player_lives)
		Globals.language = config.get_value("Globals","language", Globals.language)
		print_debug("config loaded!")
	
	$CanvasLayer/Control/LabelMode.visible = Globals.debug_mode
		
	var _dir_list := _create_game_dir()
	_populate_games(_dir_list)
	
	Globals.connect("update_player_scores", self, "_on_update_player_scores")
	Globals.connect("player_lost_life", self, "_on_player_lost_life")

func save_settings() -> void:
	config.set_value("Globals", "play_mode", Globals.play_mode)
	config.set_value("Globals", "player_lives", Globals.max_player_lives)
	config.set_value("Globals", "language", Globals.language)
	config.save("config.cfg")
	
func _create_game_dir() -> Directory:
	var _path : String
	
	if OS.has_feature("standalone"):
		_path =  OS.get_executable_path().get_base_dir() + "/.games"
#		_path = OS.get_executable_path().get_base_dir() + "/.games/"
		print_debug("RELEASE MODE")
	else:
		Globals.debug_mode = true
		_path = ProjectSettings.globalize_path("res://.games")
#		_path = OS.get_executable_path().get_base_dir() + "/PlayJamLauncher/.games" # test path
		print_debug("DEBUG MODE")
		
	var _dir_list := Directory.new()
	
	if _dir_list.open(_path) != OK:
		
		if _dir_list.make_dir_recursive(_path) != OK:		
			print_debug("Error al abrir el directorio {0}.".format({
				0: _path
			}))	
	
	return _dir_list

func find_game(_path):
	
	var _dir := Directory.new()
	_dir.open(_path)
	_dir.list_dir_begin(true, true)
	var _file  := _dir.get_next()
	
	while _file != "":
		if _dir.current_is_dir():
			_file = find_game(_dir.get_current_dir() + "/" + _file)
			
		if !(_file.ends_with("exe")):
			_file = _dir.get_next()
			continue
			
		break
	
	_dir.list_dir_end()
	return _file

func _populate_games(_dir_list : Directory) -> void:
	_dir_list.list_dir_begin(true, true)
	var _file  = _dir_list.get_next()
	var _item_idx := 0
	
	while _file != "":
		var _subpath = _dir_list.get_current_dir() + "/" + _file
		
		if _dir_list.current_is_dir():
			_file = find_game(_subpath)
		
		n_ItemList.add_item(_file.trim_suffix(".exe"))
		n_ItemList.set_item_metadata(_item_idx, {
			Global.GAME_METADATA.PATH: _subpath,
			Global.GAME_METADATA.FILENAME: _file
		})
		
		_file = _dir_list.get_next()
		_item_idx += 1
			
	if n_ItemList.get_item_count() == 0:
		n_WarningDialog.dialog_text = "No se encontraron juegos!"
		n_WarningDialog.visible = true
		n_WarningDialog.popup_centered()
		return
	
	n_ItemList.select(0)

func _process(delta):
	current_state.process(delta)
	
func _input(event : InputEvent):
	current_state.input(event)

func set_state(_new_state : int, args := {}) -> void:
	if current_state != null:
		current_state.exit_state()
	
	current_state = MenuStates.get(_new_state)
	current_state.enter_state(args)

func _on_AcceptDialog_confirmed():
	get_tree().reload_current_scene()

func _on_ItemList_item_selected(index):
	pass
	
func add_new_player(_player) -> void:
	Globals.current_player = _player
	n_PlayerScoresList.add_child(_player)
	_sort_scores()
	
func set_player_lives(_value) -> void:
	Globals.current_player.lives = _value
	update_player_info()

func update_player_info() -> void:
	n_LabelPlayerName.text = Globals.current_player.get_name()
	n_LabelPlayerLives.text = "VIDAS: {0}".format({0:String(Globals.current_player.lives)})
	
func _on_update_player_scores() -> void:
	Globals.current_player.record += 500
	update_player_info()

func _on_player_lost_life() -> void:
	Globals.current_player.lives -= 1
	update_player_info()

func _sort_scores() -> void:
	var _children = n_PlayerScoresList.get_children()
	
	for i in n_PlayerScoresList.get_children():
		n_PlayerScoresList.remove_child(i)
	
	_children.sort_custom(Globals.ScoreSorter,"sort_ascending")
	
	for i in _children:
		n_PlayerScoresList.add_child(i)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()
		get_tree().quit()
