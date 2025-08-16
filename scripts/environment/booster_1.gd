extends MeshInstance3D

@export var move_component: MoveComponent
@export var boost_material: StandardMaterial3D
@export var boost_min = 2
@export var boost_max = 20
@export var boost_velocity_multiplayer = 2
@export var boost_light: OmniLight3D

var mesh_material: StandardMaterial3D

# NOTE: had to mark both Mesh (planes) and Boost Material as local for this to work
# independently on peers.
# We use the synchronized velocity property of the actual Player object to base
# the boost level. Could update to something else if needed.
# Since a greater range of velocities would produce unexpected brightness of 
# emission, clamp at boost_max.

func _ready() -> void:
	if mesh:
		mesh.surface_set_material(0, boost_material)
		mesh_material = mesh.surface_get_material(0)

func _physics_process(delta: float) -> void:
	if mesh_material:
		var speed = move_component.get_parent().velocity.length() # Player velocity
		mesh_material.emission_energy_multiplier = clamp(speed * boost_velocity_multiplayer, boost_min, boost_max)
		boost_light.light_energy = clamp(speed * 0.01, 0.1, 3.0)
