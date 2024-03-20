extends Resource
class_name Dialogs

@export var dialogs: Array[Dialog] = []

func get_dialog(lang_code: String, key: String) -> String:
	var dialog_index := -1
	
	var i := 0
	for dialog in dialogs:
		if dialog.key == key:
			dialog_index = i
			break
		i = i + 1
	
	if dialog_index == -1:
		return "[DIALOG NOT FOUND]"
	else:
		return dialogs[dialog_index].get_dialog(lang_code)
	
