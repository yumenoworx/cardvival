extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label/AnimationPlayer.play("loading")
	$CPUParticles2D.texture = load("res://yay.png")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hide":
		queue_free()
	elif anim_name == "loading":
		var auth_window = get_parent().get_node("auth")
		if not Me.me and not auth_window:
			$Label/AnimationPlayer.play("loading")
		else:
			move_to_front()
			$AnimationPlayer.play("hide")
