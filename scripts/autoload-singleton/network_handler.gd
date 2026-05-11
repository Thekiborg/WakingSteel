extends Node

const PORT = 9999
const IP_ADDRESS = '127.0.0.1'

var enet_peer := ENetMultiplayerPeer.new()

func start_server() -> Error:
	var err = enet_peer.create_server(PORT)
	if err == OK:
		multiplayer.multiplayer_peer = enet_peer
		multiplayer.peer_connected.connect(_peer_connected)
		multiplayer.peer_disconnected.connect(_peer_disconnected)
		_on_connected_to_server()
		return OK
	else:
		return err


func join_server(ip: String, port: int) -> void:
	enet_peer.create_client(ip, port)
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.multiplayer_peer = enet_peer


func _peer_connected(peer_id: int) -> void:
	if peer_id == 1:
		print("Host connected and game started.")
	else:
		print( peer_id, " connected")
	
	var baseplate = Preloads.FLOOR.instantiate()
	get_tree().current_scene.add_child.call_deferred(baseplate)

	var new_player = Preloads.PLAYER.instantiate()
	new_player.name = str(peer_id)
	var rand_x = randf_range(-3., 3.)
	var rand_z = randf_range(-3., 3.)
	new_player.position = Vector3(rand_x, 2., rand_z)
	get_tree().current_scene.add_child(new_player)


func _peer_disconnected(peer_id: int) -> void:
	if peer_id == 1:
		print("Shutting off server.")
	else:
		print(peer_id, " disconnected")

	if peer_id == 1:
		leave_server()
	
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	var player_to_remove = players.find_custom(func(p): return p.name == str(peer_id))
	if player_to_remove != -1:
		players[player_to_remove].queue_free()


func leave_server() -> void:
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	clean_up_signals()
	get_tree().reload_current_scene()


func _on_connected_to_server() -> void:
	_peer_connected(multiplayer.get_unique_id())


func clean_up_signals() -> void:
	multiplayer.peer_connected.disconnect(_peer_connected)
	multiplayer.peer_disconnected.disconnect(_peer_disconnected)
	if multiplayer.connected_to_server.is_connected(_on_connected_to_server):
		multiplayer.connected_to_server.disconnect(_on_connected_to_server)
