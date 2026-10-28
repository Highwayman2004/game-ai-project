extends RigidBody3D
class_name Throwable_object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Object")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
