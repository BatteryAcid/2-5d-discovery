class_name MoveController
extends Node

# TODO: make levels small, provide height restriction that once reached causes ship to stall, and restarts after X seconds to they have to quickly react
# TODO: should we create a separate script to house health and stuff like that
# - see example project. they added it as a separate component, not resource.
# Properties are things that effect the object like speed
# Attributes are things intrinsic like health, velocity
# TODO need one for properites to be synched

# NOTE: MoveAttributes is marked Local to Scene so that if values differ between
# peers, they won't be overridded by authority.
@export_group("Movement Attributes")
@export var move_attributes: MoveAttributes

@export_group("Movement Components")
@export var input_component: InputComponent
@export var move_component: MoveComponent

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return

	if input_component.hold:
		move_component.velocity = Vector3.ZERO
		move_attributes.speed = 0
		return
	
	if input_component.up_pressed:
		move_attributes.speed = min(move_attributes.speed + move_attributes.acceleration * delta, move_attributes.max_speed)
	elif input_component.down_pressed:
		move_attributes.speed = max(move_attributes.speed - move_attributes.acceleration * delta, -move_attributes.max_speed * move_attributes.backward_ratio)
	else:
		# Slow down if no key pressed
		move_attributes.speed -= move_attributes.speed * delta

	var forward = move_component.actor.global_transform.basis.z.normalized()
	
	move_component.velocity = forward * move_attributes.speed
