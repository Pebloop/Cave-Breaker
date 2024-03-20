extends Resource
class_name DialogsActionManager

@export var dialogs_action : Array[DialogsActionManagerCell]

func get_dialog_action(key: String) -> DialogAction:
	for dialog_action in dialogs_action:
		if dialog_action.key == key:
			return dialog_action.dialog_action
	return null
	
