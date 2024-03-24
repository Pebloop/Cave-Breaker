extends DialogEvent
class_name DialogEventOpenRoom

@export var room_id: int

func execute(node: Node, tree: SceneTree):
	var rooms_manager: RoomsManager = tree.root.get_node("/root/SceneGuiHome/SceneHome/RoomsManager")
	
	if not rooms_manager:
		push_error("Could not find room manager.")
	
	await rooms_manager.openRoom(room_id, true, true)
