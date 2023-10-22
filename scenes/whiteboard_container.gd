extends SubViewportContainer


func _gui_input(event):
	$SubViewport.push_input(event)
