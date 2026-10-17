extends State
class_name Guard_wait

@export var wait_time: float = 2.0
var time_left: float


func Enter():
	time_left = wait_time


func Physics_Update(delta:float):
	guard.velocity.x = 0
	guard.velocity.z = 0
	
	time_left -= delta
	if time_left <= 0.0:
		Transitioned.emit(self, "Patrol")
