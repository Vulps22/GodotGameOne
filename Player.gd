extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary

var movement_direction : Vector3

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return

	rpc("do_movement_state", movement_states["stand"].to_dict())


func _input(event):
	if not is_multiplayer_authority():
		return
		
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")

func _physics_process(_delta):
	if not is_multiplayer_authority():
		return
		
	if is_movement_ongoing():
		if Input.is_action_pressed("sprint"):

			rpc("do_movement_state", movement_states["sprint"].to_dict())
			
		elif Input.is_action_pressed("walk"):

			rpc("do_movement_state", movement_states["walk"].to_dict())
		else:

			rpc("do_movement_state", movement_states["run"].to_dict())
		
		emit_signal("set_movement_direction", movement_direction)
	else:
		rpc("do_movement_state", movement_states["stand"].to_dict())


@rpc("any_peer", "call_local")
func do_movement_state(_movement_state: Dictionary):
	var movement_state = MovementState.from_dict(_movement_state)
	emit_signal("set_movement_state", movement_state)


func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
