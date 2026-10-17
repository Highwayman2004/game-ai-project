extends CharacterBody3D
class_name Guard

@export var route_path: Node3D
var route_points: Array[Node3D] = []

@export var retreat_cluster: Node3D
var retreat_points: Array[Node3D] = []

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var state_machine:State_machine = $StateMachine

var current_speed: float
@export var patrol_speed: float = 2.0

var target_index: int = 0
var direction_step:int = 1

func _ready() -> void:
	if route_path != null:
		for p in route_path.get_children():
			route_points.append(p)
	
	
	if retreat_cluster != null:
		for r in retreat_cluster.get_children():
			retreat_points.append(r)
	
	if route_points.size() >= 2:
		global_position = route_points[0].global_position
		target_index = 1
	
	await  get_tree().physics_frame
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
