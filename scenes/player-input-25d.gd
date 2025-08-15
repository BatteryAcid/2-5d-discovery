class_name PlayerInput
extends Node

var right_str = 0
var left_str = 0
var up_pressed
var down_pressed

var hold: bool = false

func _physics_process(delta):
	if get_tree().get_multiplayer().multiplayer_peer != null && is_multiplayer_authority():
		right_str = Input.get_action_strength("right")
		left_str = Input.get_action_strength("left")
		
		up_pressed = Input.is_action_pressed("up")
		down_pressed = Input.is_action_pressed("down")

		# TODO: only allow in idle...
		#if hold && Input.is_anything_pressed(): 
			#print("hold cancelled")
			#hold = false
		if Input.is_action_just_pressed("h"):
			hold = !hold
		
			
