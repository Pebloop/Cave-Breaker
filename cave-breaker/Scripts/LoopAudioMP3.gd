extends AudioStreamPlayer
class_name LoopAudioMP3


# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream.set_loop(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
