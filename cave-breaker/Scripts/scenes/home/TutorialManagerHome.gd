extends Control

# Objects
@export var character_tex : TextureRect
@export var bubble_text : RichTextLabel
@export var tutorial_dialogs : Dialogs
@export var dialogs_action_manager: DialogsActionManager

var _current_dialog_action: DialogAction = null

func _ready():
	_open_tuto()
	start_dialog("TUTO_000")


func _process(delta):
	if _current_dialog_action != null:
		if Input.is_action_just_released("tap_screen"):
			if _current_dialog_action.next_action == null:
				_current_dialog_action = null
				_close_tuto()
			else:
				_current_dialog_action = _current_dialog_action.next_action
				_change_dialog(_current_dialog_action.dialog_key)
				
			
			
func start_dialog(key: String):
	var dialog_action: DialogAction = dialogs_action_manager.get_dialog_action(key)
	
	if !dialog_action:
		return
	
	_open_tuto()
	_change_dialog(dialog_action.dialog_key)
	_current_dialog_action = dialog_action
	
	
func _open_tuto():
	visible = true
	
func _close_tuto():
	visible = false

func _change_dialog(key: String) -> void:
	var dialog := tutorial_dialogs.get_dialog("FR", key)
	
	bubble_text.text = "[center][color=#000000]" + dialog + "[/color][/center]"
