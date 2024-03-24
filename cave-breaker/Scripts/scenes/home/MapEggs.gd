extends TouchScreenButton
class_name MapEggs

@export var level: GameLevel = null

var is_active := false

var disabled := false

func activate():
	is_active = true
	
func disable_events():
	disabled = true
	
func enable_events():
	disabled = false
	

func _ready():
	pass


func _process(delta):
	pass



func _on_pressed():
	if not is_active or disabled:
		return
	
	var gameData: SceneSwitcher.GameData = SceneSwitcher.GameData.new()
	gameData.level = level
	
	SceneSwitcher.gameData = gameData
	get_tree().change_scene_to_file("res://cave-breaker/Scenes/SceneGUI_Game.tscn")
