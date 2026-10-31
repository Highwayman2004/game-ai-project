extends RigidBody3D
class_name Throwable_object

func _ready() -> void:
	add_to_group("Object")

func throw_object(dir: Vector3):
	linear_velocity = dir.normalized() * 10.0
