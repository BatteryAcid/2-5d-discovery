class_name RotateController
extends Node

# NOTE: RotateAttributes is marked Local to Scene so that if values differ between
# peers, they won't be overridded by authority.
@export_group("Rotate Attributes")
@export var rotate_attributes: RotateAttributes

@export_group("Rotate Components")
@export var input_component: InputComponent
@export var move_component: MoveComponent
@export var mouse_component: MouseComponent

var roll_input: float = 0
var relative_mouse: Vector2
var last_relative_mouse: Vector2

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
		
	if input_component.hold:
		# TODO: this is in the right direction:
		# This does move the spin down to a stop
		# Still needs to level the roll
		#but doesn't work when turning left, because it's alreayd negative
		relative_mouse = relative_mouse.move_toward(Vector2.ZERO, delta * 5)
		# TODO: hold should level the ship and camera
		#return
	else:
		relative_mouse = mouse_component.relative_mouse
	
	# Pitch
	relative_mouse.y = lerp(last_relative_mouse.y, relative_mouse.y, rotate_attributes.turn_input_response * delta)
	relative_mouse.x = lerp(last_relative_mouse.x, relative_mouse.x, rotate_attributes.turn_input_response * delta)
	
	move_component.basis = move_component.basis.rotated(move_component.basis.x, relative_mouse.y * rotate_attributes.rotation_speed * delta)
	move_component.basis = move_component.basis.rotated(move_component.basis.y, -relative_mouse.x * rotate_attributes.rotation_speed * delta)
	
	# Roll
	roll_input = lerpf(roll_input,
		input_component.right_str - input_component.left_str,
		rotate_attributes.roll_input_response * delta)
		
	move_component.basis = move_component.basis.rotated(move_component.basis.z, roll_input * 1.9 * delta)
	
	move_component.basis = move_component.basis.orthonormalized()
	
	last_relative_mouse = relative_mouse
