extends Panel

var completed = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_login_button_down():
	var nickname = $Nickname.text
	var password = $Password.text
	print(nickname)
	print(password)
	if $Nickname.text.replace(" ", "") == "" or $Password.text.replace(" ", "") == "":
		if $Nickname.text.replace(" ", "") == "":
			$NicknameError.text = "Введи свой никнейм"
		if $Password.text.replace(" ", "") == "":
			$PasswordError.text = "Введи свой пароль"
		return
	$Login.disabled = true
	var login = HTTPRequest.new()
	$Label/AnimationPlayer.play("loading")
	$Timer.start(15)
	completed = false
	add_child(login)
	login.request_completed.connect(self._http_request_completed)
	login.request("http://localhost:5230/auth/login?nickname={n}&password={p}".format({"n": nickname, "p": password}))


func _on_close_button_down():
	$AnimationPlayer.play_backwards("enable")


func _http_request_completed(result, response_code, headers, body):
	body = JSON.parse_string(body.get_string_from_utf8())
	if body and not "error" in body.keys():
		Me.me = body
		Me.update_data()
		$Label/AnimationPlayer.play("login_completed")
		var party_time = get_parent().get_node("CPUParticles2D") as CPUParticles2D
		party_time.texture = load("res://waving_hand.png")
		party_time.emitting = true
		$Timer.start(3)
		return
	else:
		$Label/AnimationPlayer.stop()
		if body and "error" in body.keys():
			var error = $Label/AnimationPlayer.get_animation("error") as Animation
			error.track_set_key_value(2, 0, body["error"])
			$Label/AnimationPlayer.play("error")
			return
		else:
			$Label/AnimationPlayer.play("connection_error")
			return
	completed = true
	$Login.disabled = false


func _on_animation_player_animation_finished(anim_name):
	if not completed and anim_name == "loading":
		$Label/AnimationPlayer.play("loading_dots")
	if anim_name == "loading_dots":
		if not completed:
			$Label/AnimationPlayer.play("loading_dots")
		else:
			$Label/AnimationPlayer.play_backwards("loading")


func _on_timer_timeout():
	if not completed:
		var party_time = get_parent().get_node("CPUParticles2D") as CPUParticles2D
		if party_time.emitting:
			party_time.emitting = false
			$Timer.start(1.5)
			return
		elif $Login.disabled and not party_time.emitting:
			get_parent().get_node("AnimationPlayer").play("hide")
			completed = true
			return
		completed = true
		$Login.disabled = false
		$Label/AnimationPlayer.play("connection_error")
