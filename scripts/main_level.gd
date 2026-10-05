extends Node

@export var player_start: Node3D
@export var player: CharacterBody3D

@export var start_points: Array[Node3D]
@export var guards: Array[CharacterBody3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = player_start.position
	player.rotate_y(PI)
	
	#for i in start_points.size():
		#guards[i].global_position = start_points[i].position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
