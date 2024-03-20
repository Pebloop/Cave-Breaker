extends Control
class_name OAuth2

const PORT := 8080
const localhost := "localhost"
const BINDING := "https://cave-breaker.pebloop.dev"
const client_secret := "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"
const client_ID := "442762602296-0qra5m9aqqvrv88f1vogh4rm5pr2e2v8.apps.googleusercontent.com"
const auth_server := "https://accounts.google.com/o/oauth2/v2/auth"
const token_req := "https://oauth2.googleapis.com/token"

var redirect_uri := BINDING
var token
var refresh_token

signal token_recieved


func _ready():
	set_process(false)
	
	# Check os
	var os = OS.get_name()
	
	# Try to find token in page
	if os == "Web":
		var params = JavaScriptBridge.eval("new URLSearchParams(window.location.search).get('code')")
		if params:
			await get_token_from_auth(params)
			if !await is_token_valid():
				await refresh_tokens()
	


func authorize():
	load_tokens()
	
	if !await is_token_valid():
		if !await refresh_tokens():
			get_auth_code()


func _process(_delta):
	pass

func get_auth_code():
	set_process(true)
	
	var body_parts = [
		"client_id=%s" % client_ID,
		"redirect_uri=%s" % redirect_uri,
		"response_type=code",
		"scope=https://www.googleapis.com/auth/youtube.readonly",
	]
	var url = auth_server + "?" + "&".join(PackedStringArray(body_parts))
	
	JavaScriptBridge.eval("window.location.href = '" + url + "'")


func get_token_from_auth(auth_code):
	
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	headers = PackedStringArray(headers)
	
	var body_parts = [
		"code=%s" % auth_code, 
		"client_id=%s" % client_ID,
		"client_secret=%s" % client_secret,
		"grant_type=authorization_code",
		"access_type=offline",
		"prompt=consent",
		"redirect_uri=%s" % redirect_uri,
	]
	
	var body = "&".join(PackedStringArray(body_parts))
	
# warning-ignore:return_value_discarded
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.accept_gzip = false
	
	var error = http_request.request(token_req, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())

	token = response_body["access_token"]
	refresh_token = response_body["refresh_token"]
	
	save_tokens()
	emit_signal("token_recieved")

func refresh_tokens():
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	
	var body_parts = [
		"client_id=%s" % client_ID,
		"client_secret=%s" % client_secret,
		"refresh_token=%s" % refresh_token,
		"grant_type=refresh_token"
	]
	var body = "&".join(PackedStringArray(body_parts))
	
# warning-ignore:return_value_discarded
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.accept_gzip = false
	
	var error = http_request.request(token_req, headers, HTTPClient.METHOD_POST, body)

	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())
	
	if response_body.get("access_token"):
		token = response_body["access_token"]
		save_tokens()
		emit_signal("token_recieved")
		return true
	else:
		return false


func is_token_valid() -> bool:
	if !token:
		await get_tree().create_timer(0.001).timeout
		return false
	
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	
	var body = "access_token=%s" % token
# warning-ignore:return_value_discarded
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.accept_gzip = false
	
	var error = http_request.request(token_req + "info", headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	
	var expiration = JSON.parse_string(response[3].get_string_from_utf8()).get("expires_in")
	
	if expiration and int(expiration) > 0:
		emit_signal("token_recieved")
		return true
	else:
		return false


# SAVE/LOAD
const SAVE_DIR = 'user://token/'
var save_path = SAVE_DIR + 'token.dat'


func save_tokens():
	if !DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, 'abigail')
	if file.is_open():
		var tokens = {
			"token" : token,
			"refresh_token" : refresh_token
		}
		file.store_var(tokens)
		file.close()


func load_tokens():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, 'abigail')
		if file.is_open():
			var tokens = file.get_var()
			token = tokens.get("token")
			refresh_token = tokens.get("refresh_token")
			file.close()


func load_HTML(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var HTML = file.get_as_text().replace("    ", "\t").insert(0, "\n")
		file.close()
		return HTML
