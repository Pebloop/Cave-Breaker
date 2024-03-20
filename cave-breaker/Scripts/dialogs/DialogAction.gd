extends Resource
class_name DialogAction

@export var dialog_key : String
@export var next_action : DialogAction = null
@export var choices : Array[DialogAction] = []
