extends Resource
class_name EggDatabase

@export var eggs: Array[Egg] = []

func get_egg(id: String):
	for egg in eggs:
		if egg.id == id:
			return egg
	push_error(id + " is not a valid egg.")
	return null
