extends State
class_name Guard_chase

@export var chase_speed: float = 3.5

func Enter():
	pass


func Physics_Update(delta:float):
	guard.get_speed_and_rotation(delta, chase_speed)
	
	if !guard.player_detected and guard.player_target == null:
		Transitioned.emit(self,"Patrol")
		return

	if guard.player_detected and guard.time_to_retreat:
		Transitioned.emit(self, "Retreat")
		return
	
	if guard.player_detected == false:
		Transitioned.emit(self,"Patrol")
		return
	
	guard.nav_agent.target_position = guard.player_target.global_position
