extends Area2D

var grab = null
var dropped = false
var cooldown = false
var from_pos = null
var stats = null
var current_cooldown_time = 0
var cooldown_time = 0
var area = null
var completed = false


func _ready():
	$AnimationPlayer.play("on_ready")
	take_item()


func _process(delta):
	if cooldown and cooldown_time > 0 and not completed:
		current_cooldown_time += delta
		$RadialProgress.max_value = cooldown_time
		$RadialProgress.progress = current_cooldown_time
		if current_cooldown_time >= cooldown_time:
			if area.get_parent().stats["hp"] <= 0:
				area.get_parent().refill()
				var http = HTTPRequest.new()
				add_child(http)
				http.request_completed.connect(_update_info)
				http.request(Data.address + "/api/me?token={t}".format({"t": Data.me["token"]}))
			else:
				var anim = $AnimationPlayer.get_animation("hide") as Animation
				anim.track_set_key_value(0, 0, global_position)
				anim.track_set_key_value(0, 1, from_pos)
				$AnimationPlayer.play("hide")
			completed = true
	if completed:
		return
	if Input.is_action_just_released("tap"):
		dropped = true
	area = null
	if dropped and get_overlapping_areas():
		area = get_overlapping_areas()[len(get_overlapping_areas())-1]
	if grab and not dropped:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		position = get_viewport().get_mouse_position() - grab
	if dropped and area and area.get_parent().get_meta("id") and not cooldown and not completed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		global_position = area.get_node("Sprite2D").global_position
		if not cooldown:
			var http = HTTPRequest.new()
			add_child(http)
			http.request_completed.connect(_attacked)
			var api = Data.address + "/api/workspaces/workspace/{w}/interact/{s}?with={i}&token={t}"
			http.request(api.format({"w": Data.workspaces[0]["id"], "s": area.get_parent().get_meta("id"), "i": stats["id"], "t": Data.me["token"]}))
			print(api.format({"w": Data.workspaces[0]["id"], "s": area.get_parent().get_meta("id") -1, "i": stats["id"], "t": Data.me["token"]}))
			cooldown = true
	elif dropped and not cooldown:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var anim = $AnimationPlayer.get_animation("hide") as Animation
		area = null
		anim.track_set_key_value(0, 0, global_position)
		anim.track_set_key_value(0, 1, from_pos)
		$AnimationPlayer.play("hide")


func take_item():
	$AudioStreamPlayer2D.stream = load("res://sounds/card/deal.mp3")
	$AudioStreamPlayer2D.play()
	Data.current_card_selected = self
	from_pos = global_position
	grab = get_viewport().get_mouse_position() - position


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hide":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Data.current_card_selected = null
		queue_free()


func _attacked(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	if response:
		if not response.has("error"):
			cooldown_time = response["cooldown"]
			area.get_parent().update_hp(response["damage"])
			Data.me["wallet"]["gold"] = response["wallet"]["gold"]
			Data.me["inventory"] = response["inventory"]
			var rand_sound = randi() % 6 + 1
			print(rand_sound)
			var sound = "res://sounds/{i}/{r}.wav".format({"i": stats["texture"], "r": rand_sound})
			$AudioStreamPlayer2D.stream = load(sound)
			$AudioStreamPlayer2D.play()
			$RadialProgress/AnimationPlayer.play("cooldown")
		else:
			Error.show_error(response["error"])
			var anim = $AnimationPlayer.get_animation("hide") as Animation
			anim.track_set_key_value(0, 0, global_position)
			anim.track_set_key_value(0, 1, from_pos)
			$AnimationPlayer.play("hide")
	else:
		Error.show_error("Сервер не вернул значений")
		var anim = $AnimationPlayer.get_animation("hide") as Animation
		anim.track_set_key_value(0, 0, global_position)
		anim.track_set_key_value(0, 1, from_pos)
		$AnimationPlayer.play("hide")


func _update_info(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	if response:
		if not response.has("error"):
			Data.me = response
			var anim = $AnimationPlayer.get_animation("hide") as Animation
			anim.track_set_key_value(0, 0, global_position)
			anim.track_set_key_value(0, 1, from_pos)
			$AnimationPlayer.play("hide")
		else:
			Error.show_error(response["error"])
			var anim = $AnimationPlayer.get_animation("hide") as Animation
			anim.track_set_key_value(0, 0, global_position)
			anim.track_set_key_value(0, 1, from_pos)
			$AnimationPlayer.play("hide")
	else:
		Error.show_error("Server isn't responding...")
		var anim = $AnimationPlayer.get_animation("hide") as Animation
		anim.track_set_key_value(0, 0, global_position)
		anim.track_set_key_value(0, 1, from_pos)
		$AnimationPlayer.play("hide")
