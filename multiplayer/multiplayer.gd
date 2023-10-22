extends HTTPRequest


func update_player_info(tag):
	request("http://localhost:52300/api/user?tag=%s" % tag)

func _on_request_completed(result, response_code, headers, body):
	print("result: " + str(body))
	print("response_code: " + str(response_code))
	print("headers: " + str(headers))
	print("body: " + str(JSON.parse_string(body.get_string_from_utf8())))
