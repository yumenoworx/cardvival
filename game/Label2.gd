extends Label



func _on_gui_input(event):
	if event.is_action_pressed("tap"):
		if name == "YumeNoWorx":
			OS.shell_open("https://t.me/yumenoworx")
		else:
			OS.shell_open("https://yukihtml.ru")
