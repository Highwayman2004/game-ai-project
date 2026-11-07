extends RigidBody3D
class_name Throwable_object

signal impact_sound_made(pos: Vector3, volume: float)

@onready var clink_sound_player: AudioStreamPlayer3D = $ClinkSoundPlayer

var time_to_colision: float = .1
var time_left: float
var can_play_sound: bool = false

func _ready() -> void:
	add_to_group("Object")
	time_left = time_to_colision
	var enemies: Array = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() > 0:
		for e in enemies:
			impact_sound_made.connect(e.detect_sound)

func throw_object(dir: Vector3, thrower: PhysicsBody3D = null):
	linear_velocity = dir.normalized() * 15.0
	if thrower:
		add_collision_exception_with(thrower)
		await get_tree().create_timer(0.3)
		remove_collision_exception_with(thrower)


func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0:
		can_play_sound = true


func _on_body_entered(body: Node) -> void:
	if can_play_sound:
		clink_sound_player.play()
		impact_sound_made.emit(global_position, 10.0)
