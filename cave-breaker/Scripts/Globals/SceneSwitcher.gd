extends Node

# Game related data
class GameData:
	var board: Array[int] = []
	var width: int = 1
	var height: int = 1
	var eggs: Array[Egg] = []
	
var gameData: GameData = GameData.new()
