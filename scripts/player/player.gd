extends CharacterBody3D
class_name Player

@onready var head: Node3D = $Head
@onready var player_camera: Camera3D = $Head/PlayerCamera
@export var sensitivity: float = 0.001

@export var item_pick_up_label: Control
@export var crosshair: Control
@onready var player_ray_cast: RayCast3D = $Head/PlayerCamera/RayCast

@onready var gun: Node3D = $Head/PlayerCamera/Gun
@onready var gun_ray: RayCast3D = $Head/PlayerCamera/Gun/RayCast3D
var using_gun: bool

@onready var throwable: Node3D = $"Head/PlayerCamera/Throwable object"
@onready var throw_point: Node3D = $"Head/PlayerCamera/Throwable object/ThrowPoint"
@onready var throw_aim_point: Node3D = $Head/PlayerCamera/ThrowAimPoint
var using_throwable: bool
@export var throwable_scene: PackedScene

@export var speed: float = 5.0
@export var sprint_speed: float = 7.0
var current_speed:float
const jump_velocity = 4.5

var twist_input: float = 0.0
var pitch_input: float = 0.0

var flying: bool = false
@onready var player_collider: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_speed = speed
	item_pick_up_label.visible = false
	use_gun()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative = event.relative * sensitivity
		head.rotate_y(-relative.x)
		player_camera.rotate_x(-relative.y)
		player_camera.rotation.x = clamp(player_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	throwable_object_detection()

func _physics_process(delta: float) -> void:
	player_controls(delta)


func player_controls(delta: float):
	if flying:
		velocity = Vector3.ZERO
		player_collider.disabled = true
	else:
		velocity += get_gravity() * delta
		player_collider.disabled = false

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
	
	if Input.is_action_just_pressed("attack"):
		if using_gun:
			if gun_ray.is_colliding():
				var collider = gun_ray.get_collider()
				if collider.is_in_group("Enemy"):
					collider.take_damage(10, self)
		elif using_throwable:
			var object = throwable_scene.instantiate()
			get_tree().current_scene.add_child(object)
			object.global_position = throw_point.global_position
			object.add_collision_exception_with(self)
			var throw_dir = throw_aim_point.global_position - throw_point.global_position
			object.throw_object(throw_dir)
			use_gun()
	
	move_and_slide()


func use_gun():
	using_gun = true
	gun.visible = true
	using_throwable = false
	throwable.visible = false


func use_throwable():
	using_throwable = true
	throwable.visible = true
	using_gun = false
	gun.visible = false


func throwable_object_detection():
	var label_text: Label = item_pick_up_label.get_child(0)
	item_pick_up_label.visible = false
	
	if not player_ray_cast.is_colliding():
		return
	else:
		var collider = player_ray_cast.get_collider()
		if collider.is_in_group("Object"):
			item_pick_up_label.visible = true
			if !using_throwable:
				label_text.text = "E) Pick up item"
				if Input.is_action_just_pressed("interact") and !using_throwable:
					use_throwable()
					collider.queue_free()
					item_pick_up_label.visible = false
			else:
				label_text.text = "You already have an item"
