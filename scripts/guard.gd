extends CharacterBody3D

@export var route_path: Node3D
var route_points: Array[Node3D] = []

#@export var retreat_cluster: Node3D
#var retreat_points: Array[Node3D] = []

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var wait_timer: Timer = $WaitTimer
var waiting:= false

@export var def_speed: float = 2.0

var speed: float

var target_index: int = 0
var direction_step:int = 1

func _ready() -> void:
	for p in route_path.get_children():
		route_points.append(p)
		
	target_index = 1 % route_points.size()
	
	if route_points.size() < 2: return
#
	##for r in retreat_cluster:
		##retreat_points.append(r.global_position)
	global_position = route_points[0].global_position
	nav_agent.target_position = route_points[target_index].global_position
	
	speed = def_speed


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0
	
	if waiting == true:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	
	#for i in route_points.size():
		#target_index = i
		#if nav_agent.is_navigation_finished():
			#i+=1
			#nav_agent.target_position = route_points[target_index].global_position
		#
		#speed = def_speed
		#var target_position = nav_agent.get_next_path_position()
		#var direction = target_position - global_position
		#direction = direction.normalized()
		#velocity = direction * speed
		#move_and_slide()
	
	if nav_agent.is_navigation_finished():
		waiting = true
		wait_timer.start()
		
		#target_index += 1 
		#nav_agent.target_position = route_points[target_index].global_position
		return
		
	#if target_index <= route_points.size():
			#target_index = 0
	
	var target_position = nav_agent.get_next_path_position()
	var direction = target_position - global_position
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	#velocity = direction * speed
	
	if direction.length() > 0.01:
		var target_yaw = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, 2 * delta)

	move_and_slide()

func _on_wait_timer_timeout() -> void:
	waiting = false
	
	
	var next_target_index: int = target_index + direction_step
	if next_target_index >= route_points.size() or next_target_index < 0:
		direction_step *= -1
		next_target_index = target_index + direction_step
	#target_index = (target_index + 1) % route_points.size()
	target_index = next_target_index
	nav_agent.target_position = route_points[target_index].global_position
