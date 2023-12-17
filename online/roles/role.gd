extends Node
# res://online/roles/textures/coin.png

func get_role_color(type):
	match type:
		"donater": return Color("B5903A")
		"for_free": return Color("12572C")
		"kinger": return Color8(223, 113, 38)
		"developer": return Color("540F14")
		"yumenoworx": return Color("403353")
		_: pass


func get_role_icon(type):
	match type:
		"donater": return load("res://online/roles/textures/coin.png")
		"for_free": return load("res://online/roles/textures/no money.png")
		"kinger": return load("res://online/roles/textures/crown.png")
		"developer": return load("res://online/roles/textures/heart.png")
		"yumenoworx": return load("res://online/roles/textures/yumenoworx.png")
		_: pass
