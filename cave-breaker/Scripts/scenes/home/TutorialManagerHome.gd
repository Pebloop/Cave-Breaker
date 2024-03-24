extends Control

# Objects
@export var character_tex : TextureRect
@export var bubble_tex : NinePatchRect
@export var bubble_text : RichTextLabel
@export var tutorial_dialogs : Dialogs
@export var dialogs_action_manager: DialogsActionManager

var rooms_manager: RoomsManager

var _current_dialog_action: DialogAction = null

func _ready():
	rooms_manager = get_node("/root/SceneGuiHome/SceneHome/RoomsManager")
	start_dialog("TUTO_000")


func _process(delta):
	
	# small script that manage dialogs
	if _current_dialog_action != null:
		if Input.is_action_just_released("tap_screen"):
			bubble_tex.visible = false
			for event in _current_dialog_action.events:
				await event.execute(self, get_tree())
			bubble_tex.visible = true
			if (not _current_dialog_action) or _current_dialog_action.next_action == null:
				_current_dialog_action = null
				_close_tuto()
			else:
				_current_dialog_action = _current_dialog_action.next_action
				_change_dialog(_current_dialog_action.dialog_key)
				
			
			
func start_dialog(key: String):
	var dialog_action: DialogAction = dialogs_action_manager.get_dialog_action(key)
	
	if !dialog_action:
		return
	
	await _open_tuto()
	_change_dialog(dialog_action.dialog_key)
	_current_dialog_action = dialog_action
	
	
func _open_tuto():
	rooms_manager.disable_events()
	bubble_tex.visible = false
	visible = true
	await _gradually_appear(self)
	bubble_tex.visible = true
	
func _close_tuto():
	bubble_tex.visible = false
	await _gradually_disappear(self)
	visible = false
	rooms_manager.enable_events()

func _change_dialog(key: String) -> void:
	var dialog := tutorial_dialogs.get_dialog("FR", key)
	var nb_lines := dialog.count("\n") + 1
	
	bubble_tex.size.y = 28 * nb_lines + 10
	bubble_text.text = "[center][color=#000000]" + dialog + "[/color][/center]"

func _gradually_appear(node : Control):
	for alpha in 100.0: 
		node.modulate = Color(1,1,1,alpha / 100.0)
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.2).timeout
	
func _gradually_disappear(node : Control):
	for alpha in 100.0: 
		node.modulate = Color(1,1,1,(100.0 - alpha) / 100.0)
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.2).timeout
	
