class_name MoveComponent
extends Node

@export var actor: Node3D
@export var basis: Basis
@export var velocity: Vector3

func _ready():
	# TODO: not sure this was needed
	basis = actor.transform.basis

func _physics_process(delta):
	if not is_multiplayer_authority():
		return

	actor.transform.basis = basis
	actor.velocity = velocity
	
	actor.move_and_slide()
