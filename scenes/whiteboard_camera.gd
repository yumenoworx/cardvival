extends Camera2D

var grab = null

func _ready():
	position = Vector2(1000, 1000)

func _process(delta):
	if Input.is_action_just_pressed("tab"):
		if not Me.interacts_with:
			position = Vector2(1000, 1000)
		else:
			position = Me.interacts_with.global_position + Me.interacts_with.size / 2
	if grab:
		position = get_viewport().get_mouse_position() - grab


func _input(event):
	if true:
		if event.is_action_pressed("zoom_in"):
			if zoom.x < 1:
				zoom = Vector2(zoom.x + 0.1, zoom.y + 0.1)
		if event.is_action_pressed("zoom_out"):
			if zoom.x > 0.7:
				zoom = Vector2(zoom.x - 0.1, zoom.y - 0.1)
		if event.is_action_pressed("interact"):
			print(get_parent().get_node("Cursor").get_overlapping_bodies())
			if not get_parent().get_node("Cursor").get_overlapping_bodies():
				grab = get_viewport().get_mouse_position() - position
		if event.is_action_released("interact"):
			grab = null
