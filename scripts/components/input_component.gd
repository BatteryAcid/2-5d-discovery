class_name InputComponent
extends Node

#var input_dir : Vector2
var right_str
var left_str
var up_pressed
var down_pressed

func _physics_process(delta):
	if get_tree().get_multiplayer().multiplayer_peer != null && is_multiplayer_authority():
		right_str = Input.get_action_strength("right")
		left_str = Input.get_action_strength("left")
		
		up_pressed = Input.is_action_pressed("up")
		down_pressed = Input.is_action_pressed("down")
