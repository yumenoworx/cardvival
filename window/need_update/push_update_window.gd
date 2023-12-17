extends Node


func show_error(error_msg):
	var me = load("res://window/error/error.tscn").instantiate()
	me.get_node("PanelContainer/PanelContainer/VBoxContainer/Description").text = str(error_msg)
	get_viewport().get_tree().current_scene.add_child(me)
