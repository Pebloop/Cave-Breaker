extends BaseButton
class_name GoogleAuthButton

@export var oauth2 : OAuth2

# Called when the node enters the scene tree for the first time.
func _ready():
	var os = OS.get_name()
	
	if os == "Android":
		SignInClient.user_authenticated.connect(func(is_authenticated: bool): # (1)
			if not is_authenticated:
				SignInClient.sign_in()
			else:
				get_tree().change_scene_to_file("res://cave-breaker/Scenes/SceneGUI_Home.tscn")
		)
	elif os == "Web":
		oauth2.token_recieved.connect(_on_OAuth2_token_recieved)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_up():
	var os = OS.get_name()
	if os == "Android":
		SignInClient.sign_in()
	elif os == "Web":
		oauth2.authorize()
	elif os == "Windows":
		get_tree().change_scene_to_file("res://cave-breaker/Scenes/SceneGUI_Home.tscn")

func _on_OAuth2_token_recieved():
	get_tree().change_scene_to_file("res://cave-breaker/Scenes/SceneGUI_Home.tscn")
