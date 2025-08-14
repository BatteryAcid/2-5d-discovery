class_name MouseComponent
extends Node

@export var mouse_inverted = 1 # change to 1 for other style

# Get a vector for the mouse relative to the center of the screen
# Range(-1, 1) negative is left/top positive is right/bottom
func get_relative_mouse() -> Vector2:
	var viewport = get_viewport()
	var mouse_position = viewport.get_mouse_position()
	var center = viewport.size / 2.0
	var mouse_direction = mouse_position - center
	
	var size = max(viewport.size.x, viewport.size.y)
	return mouse_inverted * mouse_direction / size
