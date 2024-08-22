extends Resource
class_name MovementState

@export var id: int
@export var movement_speed: float
@export var acceleration: float = 6
@export var camera_fov: float = 75
@export var animation_speed: float = 1

# Method to serialize to a dictionary
func to_dict() -> Dictionary:
	return {
		"id": id,
		"movement_speed": movement_speed,
		"acceleration": acceleration,
		"camera_fov": camera_fov,
		"animation_speed": animation_speed
	}

# Static method to create a MovementState from a dictionary
static func from_dict(dict: Dictionary) -> MovementState:
	var state = MovementState.new()
	state.id = dict.get("id", 0)
	state.movement_speed = dict.get("movement_speed", 0.0)
	state.acceleration = dict.get("acceleration", 6.0)
	state.camera_fov = dict.get("camera_fov", 75.0)
	state.animation_speed = dict.get("animation_speed", 1.0)
	return state
