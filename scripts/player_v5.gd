extends CharacterBody3D
# TODO: this was used as one-file reference, can be removed
# - keeping for reference

# TODO:
# - remove semicolon

# Based on:
# https://ryanremer.itch.io/godot-ship-controller
# https://www.youtube.com/watch?v=z-Un3cVhhSs&ab_channel=RyanRemer
# Roll:
# https://kidscancode.org/godot_recipes/3.x/3d/spaceship/

# NOTE:
# I had to create a scene to ecapulate the ship model and rotate it -180 in order 
# for this to work out of the box. I'm sure there's another way to fix, but lazy...

@export var max_speed = 20.0
@export var acceleration = 20.0
@export var rotation_speed = 1.22 # feels good here
@export var enable_rotation = true
@export var enable_movement = true

@export var turn_input_response = 8.0
@export var roll_input_response = 8.0

#@onready var ship_body : Node3D = $ShipBody;
@onready var ship_body: Node3D = $CraftA#$craft_speederA
#@onready var flames_left : Flames = $ShipBody/FlamesLeft;
#@onready var flames_right : Flames = $ShipBody/FlamesRight;
#@onready var engine_material : StandardMaterial3D = load("res://ship_controller/player.tscn::StandardMaterial3D_qr3b7");
const BACKWARD_RATIO = 0.5

var speed = 0
var drift_direction = Vector3.FORWARD
var mouse_inverted = 1 # change to 1 for other style
var roll_input = 0

var relative_mouse: Vector2
var last_relative_mouse: Vector2

func _physics_process(delta):
	if enable_rotation:
		# Rotate Player
		relative_mouse = _get_relative_mouse()
		relative_mouse.y = lerp(last_relative_mouse.y, relative_mouse.y, turn_input_response * delta)
		relative_mouse.x = lerp(last_relative_mouse.x, relative_mouse.x, turn_input_response * delta)
		
		# TODO: move the get_actions to PlayerInput (composition)
		roll_input = lerpf(roll_input,
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			roll_input_response * delta)
		
		# Forward motion
		transform.basis = transform.basis.rotated(transform.basis.x, relative_mouse.y * rotation_speed * delta);
		transform.basis = transform.basis.rotated(transform.basis.y, -relative_mouse.x * rotation_speed * delta);
		
		# Roll
		transform.basis = transform.basis.rotated(transform.basis.z, roll_input * 1.9 * delta)

		transform.basis = transform.basis.orthonormalized()
		
		last_relative_mouse = relative_mouse
		
		# Rotate Ship
		var ship_basis = Basis.IDENTITY
		var scale = ship_body.scale
		ship_basis = ship_basis.rotated(Vector3.UP, -relative_mouse.x * rotation_speed / 2.0)
		ship_basis = ship_basis.rotated(Vector3.RIGHT, relative_mouse.y * rotation_speed)
		ship_basis = ship_basis.rotated(ship_basis.z, relative_mouse.x * rotation_speed)
		ship_basis = ship_basis.orthonormalized()
		ship_body.basis = ship_basis
		ship_body.scale = scale
	
	if enable_movement:
		_move_forward(delta)
		
		## Flames
		#if speed >= 0:
			#flames_left.flame_color = Color.DEEP_SKY_BLUE;
			#flames_right.flame_color = Color.DEEP_SKY_BLUE;
			#flames_left.speed_ratio = speed / max_speed;
			#flames_right.speed_ratio = speed / max_speed;
			#
			#engine_material.albedo_color = Color.DEEP_SKY_BLUE.darkened(1.0 - (speed / max_speed));
		#else:
			#flames_left.flame_color = Color.HOT_PINK;
			#flames_right.flame_color = Color.HOT_PINK;
			#flames_left.speed_ratio = speed / (-max_speed * BACKWARD_RATIO);
			#flames_right.speed_ratio = speed / (-max_speed * BACKWARD_RATIO);
			#
			#engine_material.albedo_color = Color.HOT_PINK.darkened(1.0 - (speed / (-max_speed * BACKWARD_RATIO)));
	#else:
		#engine_material.albedo_color = Color.BLACK;
		#flames_right.speed_ratio = 0.0;
		#flames_right.speed_ratio = 0.0;
			
	
func _move_forward(delta):
	var forward = ship_body.global_transform.basis.z.normalized()
	if Input.is_action_pressed("up"):
		speed = min(speed + acceleration * delta, max_speed)
	elif Input.is_action_pressed("down"):
		speed = max(speed - acceleration * delta, -max_speed * BACKWARD_RATIO)
	else:
		speed -= speed * delta
	
	velocity = forward * speed
	move_and_slide()

# Get a vector for the mouse relative to the center of the screen
# Range(-1, 1) negative is left/top positive is right/bottom
func _get_relative_mouse() -> Vector2:
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()
	var center = viewport.size / 2.0
	var mouse_direction = mouse_position - center
	
	var size = max(viewport.size.x, viewport.size.y)
	return mouse_inverted * mouse_direction / size
