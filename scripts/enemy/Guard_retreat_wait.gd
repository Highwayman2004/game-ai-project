extends State
class_name Guard_retreat_wait

@export var wait_time: float = 2.0
var time_left

func Enter():
	time_left = wait_time

func Physics_Update(delta:float):
	guard.velocity = Vector3.ZERO
	
	time_left -= delta
	
	if guard.player_detected:
		Transitioned.emit(self, "Retreat")
		return
	
	if time_left <= 0:
		Transitioned.emit(self, "Patrol")
		return
