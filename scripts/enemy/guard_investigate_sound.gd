extends State
class_name Guard_investigate_sound

@export var investigate_speed: float = 2.5
@export var wait_time: float = 3.0
var time_left: float

func Enter():
	if !guard.sound_heard:
		Transitioned.emit(self, "Patrol")
		return
	
	time_left = wait_time
	set_new_sound_position()


func Physics_Update(delta:float):
	guard.get_speed_and_rotation(delta, investigate_speed)
	
	if guard.player_detected:
		if guard.time_to_retreat:
			Transitioned.emit(self, "Retreat")
		else:
			Transitioned.emit(self, "Chase")
		return
	
	if guard.sound_heard:
		set_new_sound_position()
	
	if guard.nav_agent.is_navigation_finished():
		guard.velocity = Vector3.ZERO
		time_left -= delta
		if time_left <= 0.0:
			Transitioned.emit(self, "Patrol")
			return


func set_new_sound_position():
	guard.sound_heard = false
	guard.nav_agent.target_position = guard.sound_position
	time_left = wait_time
