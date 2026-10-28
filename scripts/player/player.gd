extends CharacterBody3D
class_name Player

@onready var head: Node3D = $Head
@onready var player_camera: Camera3D = $Head/PlayerCamera
@export var sensitivity: float = 0.001

@onready var player_ray_cast: RayCast3D = $Head/PlayerCamera/RayCast

@export var speed: float = 5.0
@export var sprint_speed: float = 7.0
var current_speed:float
const jump_velocity = 4.5

var twist_input: float = 0.0
var pitch_input: float = 0.0

var flying: bool = false
@onready var collider: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_speed = speed


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative = event.relative * sensitivity
		head.rotate_y(-relative.x)
		player_camera.rotate_x(-relative.y)
		player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	if flying:
		velocity = Vector3.ZERO
		collider.disabled = true
	else:
		velocity += get_gravity() * delta
		collider.disabled = false

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (player_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if flying:
			velocity = direction * current_speed
		else:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if Input.is_action_just_pressed("flying"):
		flying = !flying;
	
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = speed
	
	move_and_slide()
