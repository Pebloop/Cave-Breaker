extends Node2D
class_name HomeManager

@export var roomManager : RoomManager

# Called when the node enters the scene tree for the first time.
func _ready():
	roomManager.openRoom(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
