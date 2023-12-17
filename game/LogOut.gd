extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	var file = FileAccess.open("user://account.ymnwrx", FileAccess.WRITE)
	file.store_string("")
	file.close()
	get_viewport().get_tree().reload_current_scene()
