extends Node

@export var node_2D_to_delete: Node
@export var ui_to_delete: Node
@export var server_ip: String = "wss://cave-breaker.pebloop.dev"
@export var server_port: int = 7551

var _is_server = false

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	var cert = X509Certificate.new()
	var key = CryptoKey.new()
	var cert_error = cert.load("res://cert/certificate.crt")
	var key_error = key.load("res://cert/private.key")
	
	var os = OS.get_name()
	if os != "Android" && os != "iOS" && os != "Web" && os != "Windows":
		var peer = WebSocketMultiplayerPeer.new()
	
		if cert_error != OK or key_error != OK:
			return
		
		var error = peer.create_server(server_port, "*", TLSOptions.server(key, cert) )
		if error:
			print("Server launch failed.")
			return error
		multiplayer.multiplayer_peer = peer
		_is_server = true
		node_2D_to_delete.queue_free()
		ui_to_delete.queue_free()
	else:
		var peer = WebSocketMultiplayerPeer.new()
		print(server_ip + ":" + str(server_port))
		var error = peer.create_client(server_ip + ":" + str(server_port), TLSOptions.client(cert))
		if error:
			print("Connection to server failed : " + str(error))
		multiplayer.multiplayer_peer = peer
		_is_server = false
		
	if _is_server:
		print("Server launched !")
	else:
		print("Client launched !")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func is_server():
	if _is_server:
		return true
	return false
	
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	print(str(peer_id))
	
func _on_connected_fail():
	print("Connexion to server failed")
	
func _on_player_connected(id):
	print("Player : " + str(id) + " connected")
	
func _on_player_disconnected(id):
	print("Player : " + str(id) + " disconected")
