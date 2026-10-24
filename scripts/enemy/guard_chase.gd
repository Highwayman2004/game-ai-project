extends State
class_name Guard_chase

@export var chase_speed: float = 5.0

func Enter():
	pass


func Physics_Update(delta:float):
	guard.nav_agent.target_position = guard.player_target.global_position
	
	var player_position = guard.nav_agent.get_next_path_position()
	var direction = player_position - guard.global_position
	direction.y = 0
	direction = direction.normalized()
	guard.velocity.x = direction.x * chase_speed
	guard.velocity.z = direction.z * chase_speed
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		guard.rotation.y = lerp_angle(guard.rotation.y, target_yaw, 2 * delta)
	
	if guard.player_target == null:
		Transitioned.emit(self,"Patrol")
