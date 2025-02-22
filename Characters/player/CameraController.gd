extends Node

signal set_cam_rotation(_cam_rotation : float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/Camera3D

var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.07
var pitch_sensitivity : float = 0.07

var yaw_acceleration : float = 15
var pitch_acceleration : float = 15

var pitch_max : float = 60
var pitch_min : float = -30

var tween : Tween

func _ready():
	if not is_multiplayer_authority(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
	
	set_cam_rotation.emit(yaw_node.rotation.y)
	
func _on_set_movement_state(_movement_state : MovementState):
	if not is_multiplayer_authority(): return
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
