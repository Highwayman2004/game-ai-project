extends Node

@export var player_start: Node3D
@export var player: CharacterBody3D

@export var throwable_items: Node3D
var items: Array[RigidBody3D] = []

@export var item_spawn_points: Node3D
var spawns: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = player_start.position
	player.rotate_y(PI)
	
	if throwable_items != null:
		for t in throwable_items.get_children():
			items.append(t)
	
	if item_spawn_points != null:
		for s in item_spawn_points.get_children():
			spawns.append(s)
			
	for i in spawns.size():
		items[i].global_position = spawns[i].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
