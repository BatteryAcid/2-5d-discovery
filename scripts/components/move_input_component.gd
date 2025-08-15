class_name MoveInputComponent
extends Node

@export_group("Movement Attributes")
@export var move_attributes: MoveAttributes

@export_group("Movement Components")
@export var input_component: InputComponent
@export var move_component: MoveComponent
@export var model_component: ModelComponent

func _enter_tree():
	# Critical to make sure attribute values aren't shared between peer
	move_attributes.resource_local_to_scene = true

func apply_input(delta):
	if input_component.hold:
		move_component.velocity = Vector3.ZERO
		move_attributes.speed = 0
		return
	
	if input_component.up_pressed:
		move_attributes.speed = min(move_attributes.speed + move_attributes.acceleration * delta, move_attributes.max_speed)
	elif input_component.down_pressed:
		move_attributes.speed = max(move_attributes.speed - move_attributes.acceleration * delta, -move_attributes.max_speed * move_attributes.backward_ratio)
	else:
		move_attributes.speed -= move_attributes.speed * delta

	var forward = move_component.actor.global_transform.basis.z.normalized()
	
	move_component.velocity = forward * move_attributes.speed
