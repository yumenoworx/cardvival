extends Node

signal interact_result
signal workspace_update

func interact(slot, ws_id, item):
	var http = HTTPRequest.new()
	http.request("")


func _on_interact_request():
	pass
