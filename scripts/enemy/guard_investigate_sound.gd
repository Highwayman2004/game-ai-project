extends State
class_name Guard_investigate_sound

@export var wait_time: float = 5.0
var time_left: float

func Enter():
	if !guard.sound_heard:
		Transitioned.emit(self, "Patrol")
		return
	
	set_new_sound_position()


func Physics_Update(delta:float):
	if guard.player_detected:
		Transitioned.emit(self, "Chase")
		return
	
	if guard.sound_heard:
		set_new_sound_position()
	
	if guard.nav_agent.target_position <= guard.sound_position:
		guard.velocity.x = 0
		guard.velocity.z = 0
		time_left -= delta
		if time_left <= 0.0:
			Transitioned.emit(self, "Patrol")
			return
	
	
	var player_position = guard.nav_agent.get_next_path_position()
	var direction = player_position - guard.global_position
	direction.y = 0
	direction = direction.normalized()
	guard.velocity.x = direction.x * 2.0
	guard.velocity.z = direction.z * 2.0
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		guard.rotation.y = lerp_angle(guard.rotation.y, target_yaw, 2 * delta)


func set_new_sound_position():
	guard.sound_heard = false
	guard.nav_agent.target_position = guard.sound_position
	time_left = wait_time
