extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var player_camera: Camera3D = $Head/PlayerCamera
@export var sensitivity: float = 0.001

@export var speed: float = 5.0
const jump_velocity = 4.5


var twist_input: float = 0.0
var pitch_input: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#twist_input -= event.screen_relative.x * sensitivity
		#pitch_input -= event.screen_relative.y * sensitivity
		#pitch_input = clamp(pitch_input, -85, 85)
		var relative = event.relative * sensitivity
		head.rotate_y(-relative.x)
		player_camera.rotate_x(relative.y)
		player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#var current_q = basis.get_rotation_quaternion()
	#var twist_q = Quaternion(Vector3.UP, deg_to_rad(twist_input))
	#var pitch_q = Quaternion(Vector3.RIGHT, deg_to_rad(pitch_input))
	#var smoothed_q = current_q.slerp(twist_q * pitch_q, delta * 20.0)
	#basis = Basis(smoothed_q)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (player_camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
