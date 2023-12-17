extends Button
var nickname_color = null

			
func _on_button_down():
	var cp = get_parent().get_parent().get_node("ColorPicker")
	cp.visible = not cp.visible


func _on_color_picker_color_changed(color):
	modulate = color
