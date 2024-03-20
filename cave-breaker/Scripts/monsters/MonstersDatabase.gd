extends Resource
class_name MonstersDatabase

@export var monsters: Array[Monster] = []

func get_monster(id: String) -> Monster:
	for monster in monsters:
		if monster.id == id:
			return monster
	push_error(id + " is not a valid monster.")
	return null

