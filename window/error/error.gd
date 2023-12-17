extends PanelContainer
var ok = false
signal error_pushed


func _ready():
	if OS.has_feature("mobile"):
		$PanelContainer/VBoxContainer/OK/AnimationPlayer.play("on_mouse_entered")
	modulate.a = 0
	$AnimationPlayer.play("on_ready")
	


func _on_ok_button_down():
	ok = true
	$AnimationPlayer.play_backwards("on_ready")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "on_ready" and ok == true:
		get_parent().queue_free()
	elif anim_name == "on_ready":
		emit_signal("error_pushed")
	if anim_name == "on_mouse_entered":
		$PanelContainer/VBoxContainer/OK/AnimationPlayer.play(anim_name)


func _on_ok_mouse_entered():
	$PanelContainer/VBoxContainer/OK/AnimationPlayer.play("on_mouse_entered")


func _on_ok_mouse_exited():
	$PanelContainer/VBoxContainer/OK/AnimationPlayer.stop()
	$PanelContainer/VBoxContainer/OK.text = "Well"


func _on_control_gui_input(event: InputEvent):
	if event.is_action_pressed("tap"):
		ok = true
		$AnimationPlayer.play_backwards("on_ready")
