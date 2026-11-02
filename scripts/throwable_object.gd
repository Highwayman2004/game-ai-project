extends RigidBody3D
class_name Throwable_object


#@onready var audio_player: AudioStreamPlayer3D = $AudioPlayer
#@export var main_sound_effect: AudioStreamMP3
#@onready var sound_maker: Node3D = $Sound_maker

func _ready() -> void:
	add_to_group("Object")
	
	#audio_player = AudioStreamPlayer3D.new()

func throw_object(dir: Vector3):
	linear_velocity = dir.normalized() * 15.0


#func _on_body_entered(body: Node):
	#var colliders = get_colliding_bodies()
	#if colliders.size() > 0:
		#for c in colliders:
			#if c.is_in_group("Environment"):
				#print("collided")
