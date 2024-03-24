extends Node2D
class_name RoomManager

@export var eggs: Array[MapEggs] = []

var is_active: bool = false

func activate_room():
	is_active = true
	
	for egg in eggs:
		egg.activate()

func disable_events():
	if not is_active:
		return
	
	for egg in eggs:
		egg.disable_events()
		
func enable_events():
	if not is_active:
		return
	
	for egg in eggs:
		egg.enable_events()

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
