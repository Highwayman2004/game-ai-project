extends State
class_name Guard_patrol

@export var patrol_speed: float = 2.0

func Enter():
	guard.nav_agent.target_position = guard.route_points[guard.target_index].global_position


func Physics_Update(delta:float):
	guard.get_speed_and_rotation(delta, patrol_speed)
	
	if guard.player_detected and guard.player_target != null:
		get_next_target()
		if guard.time_to_retreat:
			Transitioned.emit(self, "Retreat")
		else:
			Transitioned.emit(self, "Chase")
		return
	
	if guard.sound_heard:
		get_next_target()
		Transitioned.emit(self, "InvestigateSound")
		return
	
	if guard.nav_agent.is_navigation_finished():
		get_next_target()
		guard.velocity = Vector3.ZERO
		Transitioned.emit(self, "Wait")
		return


func get_next_target():
	var next_target_index = guard.target_index + guard.direction_step
	if next_target_index >= guard.route_points.size() or next_target_index < 0:
		guard.direction_step *= -1
		next_target_index = guard.target_index + guard.direction_step
	guard.target_index = next_target_index
