extends CharacterBody3D

@export var route_path: Node3D
var route_points: Array[Node3D] = []

#@export var retreat_cluster: Node3D
#var retreat_points: Array[Node3D] = []

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var wait_timer: Timer = $WaitTimer
var waiting:= false

@export var def_speed: float = 5.0

var speed: float

var target_index: int = 0

func _ready() -> void:
	for p in route_path.get_children():
		route_points.append(p)
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
	
	if nav_agent.is_navigation_finished():
		waiting = true
		wait_timer.start()
		return
		
	var target_position = nav_agent.get_next_path_position()
	var direction = target_position - global_position
	
	if direction.length() > 0.01:
		direction = direction.normalized()
		velocity = direction * speed
		var target_yaw = atan2(direction.x, direction.z)
		rotation.y = lerp(rotation.y, target_yaw, 2 * delta)

	move_and_slide()

func _on_wait_timer_timeout() -> void:
	waiting = false
	target_index = (target_index + 1) % route_points.size()
	nav_agent.target_position = route_points[target_index].global_position
