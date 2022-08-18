extends MenuState

enum EXIT_CODES {
	WIN = 1,
	LOSE = 2,
	QUIT = 0
}

var _item_list : ItemList
var _index : int

func _init(_owner).(_owner):
	pass

func get_type() -> int:
	return Globals.MENU_STATE.GAME_EXECUTE

func enter_state(meta := {}) -> void:
	_index = meta.get(Globals.METADATA.GAME_INDEX, _index)
	_item_list = owner.n_ItemList
	
func input(event) -> void:
	pass

func process(delta) -> void:
	var _game_path = _item_list.get_item_metadata(_index)
	var _file = _game_path[Global.GAME_METADATA.PATH] + "/" + _game_path[Global.GAME_METADATA.FILENAME]
	
	print_debug("Ejecutando: {0}".format({0:_game_path}))
	
	var _exit_code
	
	owner.n_MusicPlayer.stop()
	
	if Globals.debug_mode:
		_exit_code = OS.execute(_file, [], true)
#		_exit_code = EXIT_CODES.WIN
		print_debug("exit code: " + str(_exit_code))
	else:
		_exit_code = OS.execute(_file, [], true)
		
	owner.n_MusicPlayer.play()
		
	match Globals.play_mode:
		Globals.PLAY_MODE.SINGLE:
			owner.set_state(Globals.MENU_STATE.GAME_SELECTION)
			return
		Globals.PLAY_MODE.RANDOM:
			_index = randi() % _item_list.get_item_count()
		_:
			_index = wrapi(_index + 1, 0, _item_list.get_item_count())
		
	process_exit_code(_exit_code)

func process_exit_code(_exit_code : int) -> void:
	match _exit_code:
		EXIT_CODES.WIN:
			owner.set_state(Globals.MENU_STATE.GAME_WIN)
		EXIT_CODES.LOSE:
			owner.set_state(Globals.MENU_STATE.GAME_LOSE)
		EXIT_CODES.QUIT:
			owner.set_state(Globals.MENU_STATE.GAME_SELECTION)
			print_debug("El juego fue cancelado.")
			return
	
	
