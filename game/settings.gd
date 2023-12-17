extends Control

var current_color = null
var new_color = null
var current_nickname = null
var new_nickname = " "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible and Data.me:
		current_color = Color(Data.me["nickname"][1])
		current_nickname = Data.me["nickname"][0]
		$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/Nickname.placeholder_text = Data.me["nickname"][0]
		$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/NicknameColor/HBoxContainer/Color.modulate = current_color
		$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/NicknameColor/ColorPicker.color = current_color


func _on_quit_button_down():
	visible = false


func _on_save_changes_button_down():
	new_color = $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/NicknameColor/ColorPicker.color
	if new_color != current_color:
		var http = HTTPRequest.new()
		http.request_completed.connect(_color_updated)
		add_child(http)
		var err = http.request(Data.address + "/api/me/change/nickname_color?color={c}&token={t}".format({"c": new_color.to_html(), "t": Data.me["token"]}))
		print(err)
	if new_nickname != current_nickname and new_nickname.replace(" ", "") != "":
		var http = HTTPRequest.new()
		http.request_completed.connect(_nickname_updated)
		add_child(http)
		var err = http.request(Data.address + "/api/me/change/nickname?nickname={n}&token={t}".format({"n": new_nickname, "t": Data.me["token"]}))
		print(err)


func _color_updated(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	if response:
		if not response.has("subscription_error"):
			Data.me = response
			current_color = new_color
		else:
			Error.show_error(response["subscription_error"])
	else:
		Error.show_error("Сервер не вернул значений")


func _nickname_updated(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	if response:
		if not response.has("subscription_error") and not response.has("error"):
			Data.me = response
			current_nickname = new_nickname
		elif response.has("subscription_error"):
			Error.show_error(response["subscription_error"])
		else:
			Error.show_error(response["error"])
	else:
		Error.show_error("Сервер не вернул значений")


func _on_nickname_text_changed(new_text):
	new_nickname = new_text


func _on_new_nickname_button_down():
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/NicknameColor.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/NicknameColor.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Sounds.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Sounds.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Graphics.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Graphics.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/SaveChanges.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/SaveChanges.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Quit.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Quit.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/LogOut.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/LogOut.visible


func _on_color_button_down():
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/ChangeNickname.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Nickname/ChangeNickname.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Sounds.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Sounds.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Graphics.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Graphics.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/SaveChanges.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/SaveChanges.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Quit.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/Quit.visible
	$PanelContainer/PanelContainer/CenterContainer/VBoxContainer/LogOut.visible = not $PanelContainer/PanelContainer/CenterContainer/VBoxContainer/LogOut.visible
