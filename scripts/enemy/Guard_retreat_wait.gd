extends State
class_name Guard_retreat_wait

@export var wait_time: float = 2.0
var time_left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Enter():
	time_left = wait_time

func Physics_Update(delta:float):
	guard.velocity.x = 0
	guard.velocity.z = 0
	
	time_left -= delta
	
	if guard.player_detected:
		Transitioned.emit(self, "Retreat")
		return
	
	if time_left <= 0:
		Transitioned.emit(self, "Patrol")
		return
