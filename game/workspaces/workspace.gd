extends PanelContainer

func _ready():
	var items = [1, 2, 3, 4]
	var last_location_object = null
	var i = 1
	for item in items:
		var slot = load("res://game/workspaces/slot.tscn").instantiate()
		slot.position.x = size.x/2 - (((slot.get_node("Sprite2D").texture.get_size().x * slot.get_node("Sprite2D").scale.x) + 11) * i)
		add_child(slot) 
		i += 1
