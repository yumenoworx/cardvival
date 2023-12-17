extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.current_card_selected and $Shadow.modulate.a == 0:
		$Shadow/AnimationPlayer.play("on_card_selected")
	elif not Data.current_card_selected and $Shadow.modulate.a > 0:
		$Shadow/AnimationPlayer.play_backwards("on_card_selected")
