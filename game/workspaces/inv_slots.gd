extends HBoxContainer
var old_inventory = null

func _process(delta):
	if Data.current_workspace:
		if Data.current_workspace["location"] == "home":
			visible = false
		else:
			visible = true
	if Data.me:
		if str(old_inventory) != str(Data.me["inventory"]):
			for child in get_children():
				child.queue_free()
			for item in Data.me["inventory"]:
				var slot = load("res://game/workspaces/inv_slot.tscn").instantiate()
				var path = null
				if item["type"] == "tool":
					path = "res://cards/tools/{t}.png".format({"t": item["texture"]})
				elif item["type"] == "resource":
					path = "res://cards/resources/{t}.png".format({"t": item["texture"]})
				elif item["type"] == "plant":
					path = "res://cards/plants/{t}.png".format({"t": item["texture"]})
				else:
					path = "res://cards/location_objects/{t}".format({"t": item["texture"]})
				slot.get_node("Slot/Sprite2D").texture = load(path)
				slot.stats = item
				add_child(slot)
			old_inventory = Data.me["inventory"]
