class_name MoveInputComponent
extends Node

@export_group("Movement Components")
#@export var move_stats: MoveStats
@export var input_component: InputComponent
@export var move_component: MoveComponent
@export var mouse_component: MouseComponent
@export var model_component: ModelComponent

@export_group("Movement settings")
@export var turn_input_response = 8.0
@export var roll_input_response = 8.0
@export var rotation_speed = 1.22
@export var max_speed = 20.0
@export var acceleration = 20.0
@export var speed = 0
@export var drift_direction = Vector3.FORWARD

const BACKWARD_RATIO = 0.5

# TODO: maybe put authority on these vars?
#var input_dir: Vector2
#var move_dir: int
var roll_input: float = 0
var relative_mouse: Vector2

var last_relative_mouse: Vector2

func _physics_process(delta):
	relative_mouse = mouse_component.get_relative_mouse()
	
	relative_mouse.y = lerp(last_relative_mouse.y, relative_mouse.y, turn_input_response * delta)
	relative_mouse.x = lerp(last_relative_mouse.x, relative_mouse.x, turn_input_response * delta)

	roll_input = lerpf(roll_input,
		input_component.right_str - input_component.left_str,
		roll_input_response * delta)
	
	# Forward motion
	move_component.basis = move_component.basis.rotated(move_component.basis.x, relative_mouse.y * rotation_speed * delta)
	move_component.basis = move_component.basis.rotated(move_component.basis.y, -relative_mouse.x * rotation_speed * delta)
	
	# Roll
	move_component.basis = move_component.basis.rotated(move_component.basis.z, roll_input * 1.9 * delta)
	
	move_component.basis = move_component.basis.orthonormalized()
	
	last_relative_mouse = relative_mouse
	
	_model_adjustment()
	
	# TODO: is this where this should go?
	# maybe calculate velocity rename?
	_move_forward(delta)

func _move_forward(delta):
	var forward = model_component.model.global_transform.basis.z.normalized()
	if input_component.up_pressed:
		speed = min(speed + acceleration * delta, max_speed)
	elif input_component.down_pressed:
		speed = max(speed - acceleration * delta, -max_speed * BACKWARD_RATIO)
	else:
		speed -= speed * delta

	move_component.velocity = forward * speed

func _model_adjustment():
	# Rotate Ship
	var ship_basis = Basis.IDENTITY
	var scale = model_component.model.scale
	ship_basis = ship_basis.rotated(Vector3.UP, -relative_mouse.x * rotation_speed / 2.0)
	ship_basis = ship_basis.rotated(Vector3.RIGHT, relative_mouse.y * rotation_speed)
	ship_basis = ship_basis.rotated(ship_basis.z, relative_mouse.x * rotation_speed)
	ship_basis = ship_basis.orthonormalized()
	model_component.model.basis = ship_basis
	model_component.model.scale = scale
