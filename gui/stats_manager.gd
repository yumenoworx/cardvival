extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Label/AnimationPlayer.play("loading")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = get_viewport().size.x / 2 - (size.x/2)
	if Me.me:
		$Panel/Label.text = Me.me["nickname"] + "\n" + "Level {l}".format({"l": str(0)})


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "loading":
		if not Me.me:
			$Panel/Label/AnimationPlayer.play("loading")
