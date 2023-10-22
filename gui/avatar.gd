extends Panel

var avatar = load("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
	material.set_shader_parameter("tex", avatar)
