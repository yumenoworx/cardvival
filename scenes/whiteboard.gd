extends Camera2D

var grab = null

func _ready():
	position = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)

func _process(delta):
	if grab:
		position = get_viewport().get_mouse_position() - grab


func _input(event):
	if Me.me:
		if event.is_action_pressed("zoom_in"):
			if scale.x < 1.1:
				scale = Vector2(scale.x + 0.1, scale.y + 0.1)
			print(scale.x)
		if event.is_action_pressed("zoom_out"):
			if scale.x > 0.7:
				scale = Vector2(scale.x - 0.1, scale.y - 0.1)
			print(scale.x)
		if event.is_action_pressed("interact"):
			grab = get_viewport().get_mouse_position() - position
		if event.is_action_released("interact"):
			grab = null
