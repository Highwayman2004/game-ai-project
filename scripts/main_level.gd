extends Node

@export var player_start: Node3D
@export var player: CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = player_start.position
	player.rotate_y(PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
