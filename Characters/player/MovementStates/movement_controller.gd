extends Node

@export var player : CharacterBody3D
@export var mesh_root : Node3D
@export var rotation_speed : float = 8
var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float
var cam_rotation : float

func _physics_process(delta):
	if not is_multiplayer_authority(): return
		
	if player == null:
		print("null")
		return
		
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
	var target_rotation = atan2(direction.x, direction.z) - player.velocity.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)

func _on_set_movement_state(_movement_state : MovementState):
	if not is_multiplayer_authority(): return
		
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration
	
func _on_set_movement_direction(_movement_direction : Vector3):
	if not is_multiplayer_authority(): return
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)

func _on_set_cam_rotation(_cam_rotation: float):
	if not is_multiplayer_authority(): return
	cam_rotation = _cam_rotation
