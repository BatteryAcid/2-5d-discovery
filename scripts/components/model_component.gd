class_name ModelComponent
extends Node

@export var model: Node3D
@export var mouse_component: MouseComponent
@export var model_attributes: ModelAttributes

func _enter_tree():
	# Critical to make sure attribute values aren't shared between peer
	model_attributes.resource_local_to_scene = true

func model_forward():
	return model.global_transform.basis.z.normalized()

func apply_updates():
	var relative_mouse = mouse_component.relative_mouse
	
	var ship_basis = Basis.IDENTITY
	var scale = model.scale
	ship_basis = ship_basis.rotated(Vector3.UP, -relative_mouse.x * model_attributes.rotation_speed / 2.0)
	ship_basis = ship_basis.rotated(Vector3.RIGHT, relative_mouse.y * model_attributes.rotation_speed)
	ship_basis = ship_basis.rotated(ship_basis.z, relative_mouse.x * model_attributes.rotation_speed)
	ship_basis = ship_basis.orthonormalized()
	model.basis = ship_basis
	model.scale = scale
