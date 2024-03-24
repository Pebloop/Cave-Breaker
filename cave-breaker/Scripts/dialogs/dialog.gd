extends Resource
class_name Dialog

@export var key: String = ""
@export_multiline var dialog_fr: String = ""
@export_multiline var dialog_en: String = "unused"

func get_dialog(lang_code: String) -> String:
	lang_code = lang_code.to_upper()
	match lang_code:
		"FR":
			return dialog_fr
		"EN":
			return dialog_en
	return "[ERROR]"
