class_name MouseComponent
extends Node

@export var mouse_inverted = 1 # change to 1 for other style

var relative_mouse: Vector2
var _focused = true

# Get a vector for the mouse relative to the center of the screen
# Range(-1, 1) negative is left/top positive is right/bottom
func _physics_process(delta):
	if get_parent().input_component.hold:
		relative_mouse = Vector2.ZERO
		return
	
	if get_tree().get_multiplayer().multiplayer_peer != null && is_multiplayer_authority() && _focused:
		var viewport = get_viewport()
		var mouse_position = viewport.get_mouse_position()
		var center = viewport.size / 2.0
		var mouse_direction = mouse_position - center
		
		var size = max(viewport.size.x, viewport.size.y)
		relative_mouse = mouse_inverted * mouse_direction / size

# Stop processing mouse inputs when mouse leaves window
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		_focused = false
	if what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		_focused = true
