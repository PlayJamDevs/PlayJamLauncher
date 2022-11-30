class_name PlayerScore extends GridContainer

var lives := 0 setget set_lives
var record := 0 setget set_record

func _ready():
	$LabelName.modulate = Globals.getNewPlayerColor()

func get_player_id() -> int:
	return get_index()
	
func equals(_other) -> bool:
	return get_name().to_lower() == _other.get_name().to_lower()

func get_name() -> String:
	return $LabelName.text

func set_name(_name : String) -> void:
	$LabelName.text = _name.to_upper().substr(0,3)

func set_record(_value) -> void:
	record = _value
	$LabelRecord.text = String(_value)

func set_lives(_val) -> void:
	lives = clamp(_val, 0, Globals.max_player_lives)
