extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)

func _input(event):
	if event.is_action_pressed("zoom_in"):
		if scale.x < 1.1:
			scale = Vector2(scale.x + 0.1, scale.y + 0.1)
		print(scale.x)
	if event.is_action_pressed("zoom_out"):
		if scale.x > 0.7:
			scale = Vector2(scale.x - 0.1, scale.y - 0.1)
		print(scale.x)
