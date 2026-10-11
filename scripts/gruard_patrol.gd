extends State
class_name Guard_patrol

var route_points: Array[Node3D]
var patrol_speed: float

var nav_agent: NavigationAgent3D
var target_index: int
var direction_step: int

func _ready() -> void:
	pass
	#print(speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Enter():
	patrol_speed = guard.patrol_speed
	route_points = guard.route_points
	
	nav_agent = guard.nav_agent
	target_index = guard.target_index
	direction_step = guard.direction_step
	
	target_index = 1 % route_points.size()
	
	guard.global_position = route_points[0].global_position
	nav_agent.target_position = route_points[target_index].global_position
	#print(speed)
	#var route_points = guard_script.s
	#print(route_points.size())
	#if route_points.size() > 0:
		#pass
		#guard.global_position = route_points[0].global_position
	#current_speed = patrol_speed


func Update(delta: float):
	pass


func Physics_Update(delta:float):
	if not guard.is_on_floor():
		guard.velocity += guard.get_gravity() * delta
	else:
		guard.velocity.y = 0
	
	if nav_agent.is_navigation_finished():
		#target_index = (target_index + 1) % route_points.size()
		var next_target_index: int = target_index + direction_step
		if next_target_index >= route_points.size() or next_target_index < 0:
			direction_step *= -1
			next_target_index = target_index + direction_step
		target_index = next_target_index
		nav_agent.target_position = route_points[target_index].global_position
	
	var target_position = nav_agent.get_next_path_position()
	var direction = target_position - guard.global_position
	direction.y = 0
	direction = direction.normalized()
	guard.velocity.x = direction.x * patrol_speed
	guard.velocity.z = direction.z * patrol_speed
	##velocity = direction * speed
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		guard.rotation.y = lerp_angle(guard.rotation.y, target_yaw, 2 * delta)
