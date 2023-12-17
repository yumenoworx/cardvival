extends Button

var stats = null
var refilled = true
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.me and Data.current_workspace and refilled:
		if len(JSON.parse_string(Data.current_workspace["location_objects"])) - 1 < (get_meta("id")-1):
			visible = false
			return
		else:
			visible = true
		stats = JSON.parse_string(Data.current_workspace["location_objects"])[get_meta("id")-1]
		$Slot/ProgressBar.max_value = stats["max_hp"]
		$Slot/ProgressBar.value = stats["hp"]

func update_hp(damage):
	var lo = JSON.parse_string(Data.workspaces[0]["location_objects"])
	var current_hp = lo[get_meta("id")-1]["hp"]
	lo[get_meta("id")-1]["hp"] -= damage
	Data.workspaces[0]["location_objects"] = JSON.stringify(lo)
	var anim = $Slot/ProgressBar/AnimationPlayer.get_animation("take_damage") as Animation
	anim.track_set_key_value(0, 0, current_hp)
	anim.track_set_key_value(0, 1, lo[get_meta("id")-1]["hp"])
	$Slot/ProgressBar/AnimationPlayer.play("take_damage")

func refill():
	refilled = false
	var anim = $Slot/ProgressBar/AnimationPlayer.get_animation("take_damage") as Animation
	anim.track_set_key_value(0, 0, 0)
	anim.track_set_key_value(0, 1, 100)
	$Slot/ProgressBar/AnimationPlayer.play("take_damage")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "take_damage" and not refilled:
		var lo = JSON.parse_string(Data.workspaces[0]["location_objects"])
		lo[get_meta("id")-1]["hp"] = stats["max_hp"]
		Data.workspaces[0]["location_objects"] = JSON.stringify(lo)
		refilled = true
