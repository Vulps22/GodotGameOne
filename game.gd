extends Node3D


@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://Characters/player/player_mage.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	main_menu.hide()
	
	var result = enet_peer.create_server(PORT)
	if result != OK:
		print("Failed to create server: ", result)
		main_menu.show()  # Show the menu again if server creation failed
		return
	
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	

func _on_host_button_2_pressed():
	main_menu.hide()
	
	var result = enet_peer.create_client("localhost", PORT)
	if result != OK:
		print("Failed to create server: ", result)
		main_menu.show()  # Show the menu again if server creation failed
		return
	
	multiplayer.multiplayer_peer = enet_peer
	
	add_player(multiplayer.get_unique_id())

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
