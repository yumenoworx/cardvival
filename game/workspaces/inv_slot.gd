extends Button

var stats = null
var is_hovered = false


func _on_mouse_entered():
	is_hovered = true
	if get_parent().get_parent().modulate.a == 0:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if stats["type"] == "tool":
		print("on_mouse_entered")
		$Slot/Sprite2D/AnimationPlayer.play("avaliable")
	else:
		$Slot/Sprite2D/AnimationPlayer.play("unavaliable")


func _on_mouse_exited():
	is_hovered = false
	if stats["type"] == "tool":
		$Slot/Sprite2D/AnimationPlayer.play_backwards("avaliable")


func _on_button_down():
	if (stats["type"] == "tool" or stats["type"] == "plant" and Data.current_workspace["location"] == "home") and get_parent().get_parent().modulate.a != 0:
		var item = load("res://game/workspaces/item.tscn").instantiate()
		item.stats = stats
		item.global_position = $Slot/Sprite2D.global_position
		get_parent().get_parent().get_parent().get_node("Workspace").add_child(item)
	else:
		$Slot/Sprite2D/AnimationPlayer.play("unavaliable")

func _ready():
	if stats and stats.has("qty") and stats["qty"] > 0:
		$Slot/Qty.text = "x" + str(stats["qty"])
		#$Slot/Sprite2D.material.shader = load("res://game/workspaces/bnw.gdshader")
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		#$Slot/Sprite2D.material.shader = null
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
