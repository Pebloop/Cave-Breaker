extends TouchScreenButton

@export var gameBoard: Array[int]
@export var boardWidth: int = 2

func _ready():
	pass


func _process(delta):
	pass



func _on_pressed():
	var gameData: SceneSwitcher.GameData = SceneSwitcher.GameData.new()
	gameData
	
	SceneSwitcher.gameData = gameData
	get_tree().change_scene_to_file("res://cave-breaker/Scenes/SceneGUI_Game.tscn")
