class_name Global extends Node

# signals
signal update_player_scores
signal player_lost_life

const CONFIG_FILENAME := "config.cfg"

const MIN_CHAR_SCANCODE := 65
const MAX_CHAR_SCANCODE := 91

const SCORE_PRIZE := 500
const MAX_PLAYERS := 250

const PlayerColors := [PoolColorArray()]

var debug_mode := true

var max_player_lives := 3
var play_mode = PLAY_MODE.SEAMLESS
var language = "ES"

var current_player : PlayerScore

var color_index := 0

enum METADATA {
	PLAYER_ID,
	GAME_INDEX
}

enum PLAY_MODE {
	SEAMLESS,
	SINGLE,
	RANDOM
}

enum GAME_METADATA {
	PATH,
	FILENAME
}

enum MENU_STATE {
	INTRO,
	INPUT_NAME,
	GAME_LIST_EXPAND,
	GAME_SELECTION,
	GAME_EXECUTE,
	GAME_LOSE,
	GAME_WIN
}

class ScoreSorter:
	static func sort_ascending(a, b):
		if a.record > b.record:
			return true
		return false

func _ready():
	for i in MAX_PLAYERS:
		var color = Color(randf() * i, randf() * 1, randf() * 1)
		PlayerColors.append(color)
		
func getNewPlayerColor() -> Color:
	color_index = wrapf(color_index + 1, 0, MAX_PLAYERS)
	return PlayerColors[color_index]
