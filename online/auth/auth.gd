extends Button
var auth_type = "signin"
var nickname_filter = "абвгдеёжзийклмнопрстуфхцчшщъыьэюяabcdefghijklmnopqrstuvwxyz_ -0123456789"
var auth_data = null

func _ready():
	var file = FileAccess.open("user://account.ymnwrx", FileAccess.READ)
	if file and file.get_line():
		var line = JSON.parse_string(file.get_as_text())
		if line:
			get_parent().visible = false
			print(get_parent().get_parent())
			get_parent().get_parent().get_node("Loading").visible = true
			var email = line["email"]
			var password = line["password"]
			if password and email:
				print({"email": email, "password": password})
				get_parent().visible = false
				var http = HTTPRequest.new()
				http.request_completed.connect(self._on_signin_completed)
				add_child(http)
				var err = http.request(Data.address + "/auth/login?email={e}&password={p}".format({"e": email, "p": password}))
				if err != OK:
					Error.show_error("Error " + str(err))
				file.close()
			else:
				visible = true
			return
		file.close()
	visible = true
	var random_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345689@#$%*.:_!"
	var random_value = ""
	for i in range(8):
		var random_index = randi() % random_chars.length()
		random_value += random_chars.substr(random_index, 1)
	get_parent().get_node("Password").placeholder_text = random_value
	change_type(auth_type)


func _on_button_down():
	var email = get_parent().get_node("Email").text
	var nickname = get_parent().get_node("Nickname").text
	var password = get_parent().get_node("Password").text
	var regex = RegEx.new()
	connect("error_pushed", _on_error_pushed)
	regex.compile("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(?!\\s)")
	var is_valid_email = regex.search(email)
	if not is_valid_email:
		Error.show_error("That e-mail definitely can't exist")
		return
	if " " in email:
		Error.show_error("That e-mail definitely can't exist")
		return
	if len(password) < 8:
		Error.show_error("Your password is too short")
		return
	for nickname_char in nickname.to_lower():
		if not nickname_char in nickname_filter:
			Error.show_error("Your nickname cannot contain the \"{s}\"".format({"s": nickname_char}))
			return
	auth_data = {"email": email, "password": password}
	print(auth_data)
	if auth_type == "signin":
		get_parent().visible = false
		get_parent().get_parent().get_node("Loading").visible = true
		var http = HTTPRequest.new()
		http.request_completed.connect(self._on_signin_completed)
		add_child(http)
		var err = http.request(Data.address + "/auth/login?email={e}&password={p}".format({"e": email, "p": password}))
		if err:
			Error.show_error("Error " + str(err))
	else:
		get_parent().visible = false
		get_parent().get_parent().get_node("Loading").visible = true
		var http = HTTPRequest.new()
		http.request_completed.connect(self._on_register_completed)
		add_child(http)
		var err = http.request(Data.address + "/auth/signup?email={e}&nickname={n}&password={p}".format({"e": email, "n": nickname, "p": password}))
		if err:
			Error.show_error("Error " + str(err))


func _on_alt_pressed():
	if auth_type == "signin":
		change_type("register")
	else:
		change_type("signin")


func change_type(type):
	match type:
		"signin":
			get_parent().get_node("NicknameL").visible = false
			get_parent().get_node("Nickname").visible = false
			get_parent().get_node("Auth").text = "Continue the journey"
			get_parent().get_node("Alt").text = "[Start your journey]"
			auth_type = "signin"
		"register":
			get_parent().get_node("NicknameL").visible = true
			get_parent().get_node("Nickname").visible = true
			get_parent().get_node("Auth").text = "Start the journey"
			get_parent().get_node("Alt").text = "[Continue your journey]"
			auth_type = "register"


func _on_register_completed(result, response_code, headers, body):
	print(response_code)
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response:
		if not response.has("error"):
			print("всё ок")
			if auth_data:
				var file = FileAccess.open("user://account.ymnwrx", FileAccess.WRITE)
				file.store_string(JSON.stringify(auth_data))
				file.close()
				Data.me = response
				print(Data.me)
				var http = HTTPRequest.new()
				http.request_completed.connect(self._on_get_workspaces)
				add_child(http)
				var err = http.request(Data.address + "/api/workspaces/my_own?token={t}".format({"t": Data.me["token"]}))
		else:
			Error.show_error(response["error"])
			get_parent().visible = true
			get_parent().get_parent().get_node("Loading").visible = false
	else:
		Error.show_error("сервер не вернул данных, увы...")
		get_parent().visible = true
		get_parent().get_parent().get_node("Loading").visible = false


func _on_signin_completed(result, response_code, headers, body):
	print(body)
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response:
		if not response.has("error"):
			print("всё ок")
			if auth_data:
				var file = FileAccess.open("user://account.ymnwrx", FileAccess.WRITE)
				file.store_string(JSON.stringify(auth_data))
				file.close()
			Data.me = response
			print(Data.me)
			var http = HTTPRequest.new()
			http.request_completed.connect(self._on_get_workspaces)
			add_child(http)
			var err = http.request(Data.address + "/api/workspaces/my_own?token={t}".format({"t": Data.me["token"]}))
		else:
			if "banned" in response["error"]:
				get_parent().get_parent().get_node("Loading").text = response["error"]
				return
			Error.show_error(response["error"])
			get_parent().visible = true
			get_parent().get_parent().get_node("Loading").visible = false
	else:
		Error.show_error("сервер не вернул данных, увы...")
		get_parent().visible = true
		get_parent().get_parent().get_node("Loading").visible = false

func _on_get_workspaces(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response:
		if not response.has("error"):
			Data.workspaces = response
			print(Data.workspaces)
			get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("on_auth_completed")
		else:
			Error.show_error(response["error"])
			get_parent().visible = true
			get_parent().get_parent().get_node("Loading").visible = false
	else:
		Error.show_error("сервер не вернул данных, увы...")
		get_parent().visible = true
		get_parent().get_parent().get_node("Loading").visible = false

func _on_error_pushed():
	print("ахуеть")


func _on_label_button_down():
	get_parent().get_node("Label/AudioStreamPlayer").set_stream(load("res://online/auth/hi.wav"))
	get_parent().get_node("Label/AudioStreamPlayer").playing = true
	get_parent().get_node("Label/AnimationPlayer").play("on_hi_pressed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "on_auth_completed":
		get_parent().get_parent().get_parent().queue_free()
