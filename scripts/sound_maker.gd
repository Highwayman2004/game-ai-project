extends Node3D
class_name Sound_maker

@export var audio_player: AudioStreamPlayer3D
@export var sound_range: float = 50.0
var sound_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_sound_effect():
	if audio_player.stream != null:
		if audio_player.playing:
			return
		
		audio_player.play()
		
		sound_pos = audio_player.global_position
