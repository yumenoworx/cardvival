extends VBoxContainer
var old_list = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.workspaces:
		if JSON.stringify(Data.workspaces) != old_list:
			for child in get_children():
				child.queue_free()
			for workspace in Data.workspaces:
				var ws = load("res://game/workspaces/workspace_widget.tscn").instantiate()
				ws.get_node("PanelContainer").data = workspace
				add_child(ws)
			old_list = JSON.stringify(Data.workspaces)
