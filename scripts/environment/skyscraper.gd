extends Node3D

@export var internal_light: Light3D
@export_range(0, 16) var light_energy: float = 3.7
@export_color_no_alpha var light_color

func _physics_process(delta):
	internal_light.light_energy = light_energy
	internal_light.light_color = light_color
