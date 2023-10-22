extends Area2D

var click_count = 0
var max_alpha = null
var under_mouse = false


func _ready():
	max_alpha = get_parent().modulate.a
	get_parent().modulate.a = get_parent().modulate.a / 2

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		print(click_count)
		if Me.interacts_with != get_parent() and under_mouse:
			if click_count == 0:
				$Timer.start(0.3)
			click_count += 1
			if click_count > 1:
				Me.interacts_with = get_parent()
				print(get_viewport().get_camera_2d().position)
				get_viewport().get_camera_2d().position = Me.interacts_with.global_position + Me.interacts_with.size / 2
	if Input.is_action_just_pressed("disinteract") and under_mouse:
		Me.interacts_with = null
	if Me.interacts_with != get_parent() and get_parent().modulate.a != max_alpha / 2:
		get_parent().modulate.a = get_parent().modulate.a / 2
	elif Me.interacts_with == get_parent(): get_parent().modulate.a = max_alpha
		


func _on_timer_timeout():
	click_count = 0


func _on_mouse_entered():
	under_mouse = true


func _on_mouse_exited():
	under_mouse = false
