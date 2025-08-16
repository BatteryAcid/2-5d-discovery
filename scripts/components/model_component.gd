class_name ModelComponent
extends Node

# NOTE: ModelAttributes is marked Local to Scene so that if values differ between
# peers, they won't be overridded by authority.
@export_group("Model Attributes")
@export var model_attributes: ModelAttributes

@export_group("Model Components")
@export var mouse_component: MouseComponent
@export var input_component: InputComponent

@export_group("Model")
@export var model: Node3D

func model_forward():
	return model.global_transform.basis.z.normalized()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
		
	if input_component.hold:
		return
		
	var relative_mouse = mouse_component.relative_mouse
	
	var ship_basis = Basis.IDENTITY
	var scale = model.scale
	ship_basis = ship_basis.rotated(Vector3.UP, -relative_mouse.x * model_attributes.rotation_speed / 2.0)
	ship_basis = ship_basis.rotated(Vector3.RIGHT, relative_mouse.y * model_attributes.rotation_speed)
	ship_basis = ship_basis.rotated(ship_basis.z, relative_mouse.x * model_attributes.rotation_speed)
	ship_basis = ship_basis.orthonormalized()
	model.basis = ship_basis
	model.scale = scale
