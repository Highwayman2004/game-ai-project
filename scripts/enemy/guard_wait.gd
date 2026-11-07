extends State
class_name Guard_wait

@export var wait_time: float = 2.0
var time_left: float


func Enter():
	time_left = wait_time


func Physics_Update(delta:float):
	guard.velocity = Vector3.ZERO
	
	if guard.player_detected:
		if guard.time_to_retreat:
			Transitioned.emit(self, "Retreat")
		else:
			Transitioned.emit(self, "Chase")
		return
	
	if guard.sound_heard:
		Transitioned.emit(self, "InvestigateSound")
		return
	
	time_left -= delta
	if time_left <= 0.0:
		Transitioned.emit(self, "Patrol")
		return
