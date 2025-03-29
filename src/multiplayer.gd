class_name Multiplayer extends Node

@export var host: String
@export var port: int

@export_file("*.tscn") var player_scene: String
@export_file("*.tscn") var character_scene: String

@export var host_button: Button
@export var join_button: Button
@export var multiplayer_ui: Control
var peer = ENetMultiplayerPeer.new()

func _ready():
	host_button.pressed.connect(host_lobby)
	join_button.pressed.connect(join_lobby)

func host_lobby():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer ", pid, " has joined the game!")
			add_player(pid)
	)
	add_player(multiplayer.get_unique_id())
	hide_connection_ui()

func join_lobby():
	peer.create_client(host, port)
	multiplayer.multiplayer_peer = peer
	hide_connection_ui()

func add_player(pid):
	var player = load(player_scene).instantiate()
	var character = load(character_scene).instantiate()
	player.name = str(pid)
	character.name = "character_" + str(pid)
	add_child(character, true)
	add_child(player, true)
	character.set_informations.rpc({
		"controlled_by": pid,
	})
	player.set_character.rpc(character.get_path())
	

func hide_connection_ui():
	multiplayer_ui.hide()

func show_connection_ui():
	multiplayer_ui.show()
