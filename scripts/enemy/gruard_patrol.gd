extends State
class_name Guard_patrol


func Enter():
	if guard.route_points.size() < 2: 
		return

	guard.nav_agent.target_position = guard.route_points[guard.target_index].global_position


func Physics_Update(delta:float):
	if guard.route_points.size() < 2: 
		return

	if guard.nav_agent.is_navigation_finished():
		advance_to_next_target()
		guard.velocity.x = 0
		guard.velocity.z = 0
		Transitioned.emit(self, "Wait")
		return
	
	if guard.player_detected and guard.player_target != null:
		#print(guard.player_target.position)
		advance_to_next_target()
		Transitioned.emit(self, "Chase")
		return
	
	get_target_and_direction(delta)
	

func advance_to_next_target():
	var next_target_index = guard.target_index + guard.direction_step
	if next_target_index >= guard.route_points.size() or next_target_index < 0:
		guard.direction_step *= -1
		next_target_index = guard.target_index + guard.direction_step
	guard.target_index = next_target_index
	#nav_agent.target_position = route_points[target_index].global_position


func get_target_and_direction(delta:float):
	var target_position = guard.nav_agent.get_next_path_position()
	var direction = target_position - guard.global_position
	direction.y = 0
	direction = direction.normalized()
	guard.velocity.x = direction.x * guard.patrol_speed
	guard.velocity.z = direction.z * guard.patrol_speed
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		guard.rotation.y = lerp_angle(guard.rotation.y, target_yaw, 2 * delta)
