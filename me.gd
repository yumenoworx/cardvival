extends Node

var me = null
var interacts_with = null


func _ready():
	var file = FileAccess.open("user://auth.token", FileAccess.READ)
	if file:
		var content = file.get_as_text().split("\n")
		print(content)
		var http = HTTPRequest.new()
		add_child(http)
		http.request_completed.connect(_on_request_completed)
		http.request("http://localhost:5230/api/me/{t}".format({"t": content[len(content) -1]}))
	else:
		get_viewport().get_tree().current_scene.add_child(load("res://gui/auth.tscn").instantiate())


func update_data():
	var file = FileAccess.open("user://auth.token", FileAccess.WRITE)
	file.store_string(me["token"])


func _on_request_completed(result, response_code, headers, body):
	var user = JSON.parse_string(body.get_string_from_utf8())
	if user and not "error" in user.keys():
		me = user
	else:
		get_viewport().get_tree().current_scene.add_child(load("res://gui/auth.tscn").instantiate())
