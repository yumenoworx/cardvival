extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button/AnimationPlayer.play("flying")
	$Button/AnimationPlayer2.play("lgbt_light")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size = Vector2(get_viewport().size.x, get_viewport().size.y)
	move_to_front()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "lgbt_light":
		$Button/AnimationPlayer2.play(anim_name)
	if anim_name == "lgbt_light_for_label":
		$Label/AnimationPlayer.play(anim_name)
	if anim_name == "flying":
		$Button/AnimationPlayer.play(anim_name)


func _on_button_button_down():
	$AnimationPlayer.play("hide")
