extends PanelContainer
var data = null

func _ready():
	pass


func _process(delta):
	if data != null:
		$HBoxContainer/Description/Location/Name.text = data["name"]
		$HBoxContainer/Description/Location/Location.text = "({l})".format({"l": data["location"]})
		$HBoxContainer/HBoxContainer2/LocationIcon.texture = load("res://locations/{l}/icon.png".format({"l": data["location"]}))
	if not get_parent().get_parent().name == "Info" and not get_parent().get_parent().get_parent().get_node("Workspace").visible:
		get_parent().get_parent().get_parent().get_node("QuickInfo").visible = true
		get_parent().get_parent().visible = true
		get_parent().get_parent().get_parent().get_node("End").visible = true


func _on_h_box_container_gui_input(event: InputEvent):
	if not get_parent().get_parent().name == "Info":
		if event.is_action_pressed("tap"):
			Data.current_workspace_widget = get_parent().get_parent()
			Data.current_workspace = data
			get_parent().get_parent().visible = false
			get_parent().get_parent().get_parent().get_node("End").visible = false
			get_parent().get_parent().get_parent().get_node("Workspace/GUI/Info/PanelContainer").get_node("PanelContainer").data = data
			get_parent().get_parent().get_parent().get_node("Workspace").visible = true
			get_parent().get_parent().get_parent().get_node("QuickInfo").visible = false
