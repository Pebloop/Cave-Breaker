extends DialogEvent
class_name DialogEventAddMonster

@export var monsters: Array[Monster]

func execute(node: Node, tree: SceneTree):
	for monster in monsters:
		UserData.monsters.append(MonsterInstance.new(monster))
