extends Camera2D
class_name CameraControls

@export var camera_speed := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_down"):
		position.y += delta * camera_speed
	if Input.is_action_pressed("camera_up"):
		position.y -= delta * camera_speed
	if Input.is_action_pressed("camera_left"):
		position.x -= delta * camera_speed
	if Input.is_action_pressed("camera_right"):
		position.x += delta * camera_speed
