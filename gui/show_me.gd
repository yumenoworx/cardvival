extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/Label/AnimationPlayer.play("loading")
	size.x = get_viewport().size.x / 2
	position.x = get_viewport().size.x / 2
	position.y -= get_viewport().size.y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Me.me:
		$MarginContainer/Label.text = "{n} (Level 0)".format({"n": Me.me["nickname"]})


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "loading":
		if not Me.me:
			$MarginContainer/Label/AnimationPlayer.play("loading")
