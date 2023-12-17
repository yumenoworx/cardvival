extends VBoxContainer

var animated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.current_card_selected and not animated:
		$AnimationPlayer.play("on_item_selected")
		$Slots.mouse_filter = Control.MOUSE_FILTER_IGNORE
		animated = true
	if not Data.current_card_selected and animated:
		$AnimationPlayer.play_backwards("on_item_selected")
		$Slots.mouse_filter = Control.MOUSE_FILTER_PASS
		animated = false
