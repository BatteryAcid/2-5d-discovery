class_name PlayerComponent
extends CharacterBody3D

@export_group("Player Components")
@export var model_component: ModelComponent
@export var input_component: InputComponent
@export var mouse_component: MouseComponent

@export_group("Camera")
@export var camera_3d: Camera3D
@export var spring_arm_3d: SpringArm3D

func _enter_tree():
	input_component.set_multiplayer_authority(str(name).to_int())
	mouse_component.set_multiplayer_authority(str(name).to_int())
	
	# TODO: I don't think we want the camera to be user auth, we're using the mouse
	# instead...
	#spring_arm_3d.set_multiplayer_authority(str(name).to_int())

func _ready():	
	if get_tree().get_multiplayer().get_unique_id() == str(name).to_int():
		camera_3d.current = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		camera_3d.current = false
	
	# TODO: repeat for other user-auth input synchs, like the mouse one
	# - consider grouping them together		
	# NOTE: for non-lag compensated synchronizer usage, turn off public visibility
	# and manually set the visibility to only the server/host peer. The players
	# input doesn't need to be broadcast to other peers, unless you're are using it for something.
	var ms = input_component.find_child("InputSynchronizer") as MultiplayerSynchronizer
	ms.set_visibility_for(1, true)
