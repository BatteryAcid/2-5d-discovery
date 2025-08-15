extends BADMatchHandler

func ready_player(network_id: int, player: Variant):
	if is_multiplayer_authority():
		player.name = str(network_id)
		player.position = get_spawn_point(player.name)
		
		# TODO: just for testing
		(player as CharacterBody3D).rotation = Vector3(0, 90, 0)
		
		# Player is always owned by the server
		player.set_multiplayer_authority(1)

func get_spawn_point(player_name) -> Vector3:
	# TODO: just for testing
	if player_name == "1":
		return Vector3(-20, 10, 20)
	else:
		return Vector3(-25, 10, 20)
	#return Vector3(randi_range(-50, 50), 20, randi_range(-50, 50))
	#if player_name == "1": # For now, just check if you're the host, spawn on left side.
		#return Transform3D(0, Vector2(randi_range(75, 275), randi_range(50, 570)))
	#else:
		#return Transform3D(0, Vector2(randi_range(1400, 1600), randi_range(50, 570)))
