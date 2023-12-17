extends Button


func _on_button_down():
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("VBoxContainer").visible = true
	print(Data.current_workspace_widget)
	Data.current_workspace = null
	Data.current_workspace_widget.get_parent().visible = true
	get_parent().get_parent().get_parent().get_parent().visible = false
