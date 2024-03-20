extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	SignInClient.user_authenticated.connect(func(is_authenticated: bool): # (1)
		if not is_authenticated:
			SignInClient.sign_in()
		else:
			get_tree().change_scene_to_file("res://cave-breaker/Scenes/Scene_Game.tscn")
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_up():
	SignInClient.sign_in()
