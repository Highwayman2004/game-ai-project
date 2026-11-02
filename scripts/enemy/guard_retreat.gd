extends State
class_name Guard_retreat

@export var retreat_speed: float = 3.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Enter():
	guard.nav_agent.target_position = guard.find_futhest_retreat_point()

func Physics_Update(delta:float):
	
	
	var player_position = guard.nav_agent.get_next_path_position()
	var direction = player_position - guard.global_position
	direction.y = 0
	direction = direction.normalized()
	guard.velocity.x = direction.x * retreat_speed
	guard.velocity.z = direction.z * retreat_speed
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		guard.rotation.y = lerp_angle(guard.rotation.y, target_yaw, 2 * delta)
	
	
	if guard.nav_agent.is_navigation_finished():
		guard.velocity.x = 0
		guard.velocity.z = 0
		Transitioned.emit(self, "RetreatWait")
		return
