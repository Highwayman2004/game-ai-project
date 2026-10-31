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

@onready var vision_area: Area3D = $VisionArea
@export var detection_rays: Node3D
var rays: Array[RayCast3D] = []
@onready var touch_detection_area: Area3D = $ToutchDetectionArea
var player_target: CharacterBody3D  = null
var player_detected: bool = false

@export var loose_player_time:float = 3.0
var time_since_player_last_seen: float = 0.0


@export var max_health: int = 100
var current_health: int

var target_index: int = 0
var direction_step:int = 1

func _ready() -> void:
	add_to_group("Enemy")
	
	if route_path != null:
		for p in route_path.get_children():
			route_points.append(p)
	
	
	if retreat_cluster != null:
		for r in retreat_cluster.get_children():
			retreat_points.append(r)
	
	if route_points.size() >= 2:
		global_position = route_points[0].global_position
		target_index = 1
	
	if detection_rays != null:
		for d in detection_rays.get_children():
			rays.append(d)
	
	current_health = max_health
	
	await  get_tree().physics_frame
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	check_for_player(delta)
	
	move_and_slide()


func check_for_player(delta: float):
	var player_found = false
	var detection_target = null
	
	var vision_overlaps = vision_area.get_overlapping_bodies()
	if vision_overlaps.size() > 0:
		for o in vision_overlaps:
			if o.is_in_group("Player"):
				for r in rays:
					r.force_raycast_update()
					if r.is_colliding():
						var collider = r.get_collider()
					
						if collider.is_in_group("Player") and !player_found:
							player_found = true
							detection_target = collider
				break
	
	var touch_overlaps = touch_detection_area.get_overlapping_bodies()
	if touch_overlaps.size() > 0:
		for o in touch_overlaps:
			if o.is_in_group("Player") and !player_found:
				player_found = true
				detection_target = o
	
	if player_found:
		time_since_player_last_seen = 0.0;
		player_detected = player_found
		player_target = detection_target
	else:
		time_since_player_last_seen += delta
		if time_since_player_last_seen >= loose_player_time:
			player_detected = false
			player_target = null


func take_damage(damage:int, attacker:Node3D = null):
	if current_health <= 0:
		null
	
	current_health -= damage
	
	if attacker.is_in_group("Player"):
		player_target = attacker
		player_detected = true
		time_since_player_last_seen = 0.0
		#print("damage taken")
	
	if current_health <= 0:
		queue_free()
