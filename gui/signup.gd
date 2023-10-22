extends Panel

var completed = true
var error_exists = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_login_button_down():
	var nickname = $Nickname.text
	var password = $Password.text
	var password_again = $PasswordAgain.text
	var email = $Email.text
	print(nickname)
	print(password)
	if email == "":
		$EmailError.text = "Введи свою электронную почту (me@adress.com)"
		error_exists = true
	if password == "" and password_again == "":
		$PasswordError.text = "Придумай пароль"
		error_exists = true
	elif password != password_again:
		$PasswordError.text = "Пароли не совпадают..."
		error_exists = true
	elif password == password_again and len(password) < 8:
		$PasswordError.text = "Пароль должен быть > 8 символов"
		error_exists = true
	if len(nickname) < 3:
		$NicknameError.text = "Никнейм должен быть > 8 символов"
		error_exists = true
	if error_exists:
		error_exists = false
		return
	if $Email.text.ends_with("@"):
		pass
	var login = HTTPRequest.new()
	add_child(login)
	login.request_completed.connect(self._http_request_completed)
	login.request("http://localhost:5230/auth/signup?nickname={n}&password={p}&email={e}".format({"n": nickname, "p": password, "e": email}))
	$Login.disabled = true
	$Label/AnimationPlayer.play("loading")
	completed = false


func errors():
	pass

func _on_close_button_down():
	$AnimationPlayer.play_backwards("enable")

func _http_request_completed(result, response_code, headers, body):
	body = JSON.parse_string(body.get_string_from_utf8())
	if body:
		if not "error" in body.keys():
			var party_time = get_parent().get_node("CPUParticles2D") as CPUParticles2D
			Me.me = body
			Me.update_data()
			party_time.emitting = true
			completed = false
			$Timer.start(3)
			$Login.disabled = true
			$Label/AnimationPlayer.play("reg_completed")
			return
		else:
			var error = $Label/AnimationPlayer.get_animation("error") as Animation
			error.track_set_key_value(2, 0, body["error"])
			$Label/AnimationPlayer.play("error")
			$Login.disabled = false
	else:
		$Label/AnimationPlayer.play("connection_error")
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
