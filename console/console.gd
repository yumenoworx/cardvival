extends Button

var command = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_line_text_changed(new_text):
	command = new_text

func run_script(input):
	var script = GDScript.new()
	script.set_source_code("func eval():" + input)
	script.reload()
	var ref = RefCounted.new()
	ref.set_script(script)
	return ref.eval()


func _on_button_down():
	print("Command: " + command)
	if command.begins_with("exec "):
		var script = command.replace("exec ", "")
		script = """{s}""".format({"s": script})
		print(script)
		run_script(script)
