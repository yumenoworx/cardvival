extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.me:
		$HBoxContainer/VBoxContainer/Nickname/Nickname.text = Data.me["nickname"][0]
		$HBoxContainer/VBoxContainer/Nickname/ID.text = "(ID: {id})".format({"id": str(Data.me["id"])})
		var c = Data.me["nickname"][1]
		$HBoxContainer/VBoxContainer/Nickname/Nickname.modulate = Color(c)
		$HBoxContainer/VBoxContainer/VBoxContainer/Gold.text = Data.me["wallet"]["gold"]
		if Data.me["verified"].has("status") and Data.me["verified"]["status"]:
			$HBoxContainer/VBoxContainer/Nickname/Sign.visible = true
			$HBoxContainer/VBoxContainer/Nickname/Sign.modulate = Color(c)
		else:
			$HBoxContainer/VBoxContainer/Nickname/Sign.visible = false
		if Data.me["role"]["type"]:
			$HBoxContainer/VBoxContainer/Nickname/PanelContainer.visible = true
			$HBoxContainer/VBoxContainer/Nickname/PanelContainer/HBoxContainer/Role.text = Data.me["role"]["name"]
			var color = Role.get_role_color(Data.me["role"]["type"])
			$HBoxContainer/VBoxContainer/Nickname/PanelContainer.self_modulate = color
			var icon = Role.get_role_icon(Data.me["role"]["type"])
			$HBoxContainer/VBoxContainer/Nickname/PanelContainer/HBoxContainer/Icon.texture = icon
		else:
			$HBoxContainer/VBoxContainer/Nickname/PanelContainer/HBoxContainer/Role.visible = false

func _on_texture_rect_gui_input(event):
	if event.is_action_pressed("tap"):
		print("хуй")


func _on_coin_gui_input(event: InputEvent):
	if event.is_action_pressed("tap"):
		$HBoxContainer/VBoxContainer/VBoxContainer/Coin/AudioStreamPlayer2D.stream = load("res://game/user_info/coin.wav")
		$HBoxContainer/VBoxContainer/VBoxContainer/Coin/AudioStreamPlayer2D.play()
