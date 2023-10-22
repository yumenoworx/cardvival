extends Node2D

var auth_completed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$LoginWindow/AnimationPlayer.play_backwards("enable")
	$SignupWindow/AnimationPlayer.play_backwards("enable")


func _on_sign_up_button_down():
	$SignupWindow/AnimationPlayer.play("enable")


func _on_log_in_button_down():
	$LoginWindow/AnimationPlayer.play("enable")


func _on_sign_up_pressed():
	$SignUp.button_pressed = false


func _on_log_in_pressed():
	$LogIn.button_pressed = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hide":
		queue_free()
