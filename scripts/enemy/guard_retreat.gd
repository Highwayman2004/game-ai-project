extends State
class_name Guard_retreat

@export var retreat_speed: float = 3.5


func Enter():
	guard.nav_agent.target_position = guard.find_futhest_retreat_point()

func Physics_Update(delta:float):
	guard.get_speed_and_rotation(delta, retreat_speed)
	
	if guard.nav_agent.is_navigation_finished():
		guard.velocity = Vector3.ZERO
		Transitioned.emit(self, "RetreatWait")
		return
