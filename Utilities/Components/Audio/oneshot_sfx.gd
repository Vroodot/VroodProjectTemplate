class_name OneShotSFX
extends OneShotAudioStreamPlayer

@export var pitch_max: float = 1.2
@export var pitch_min: float = 0.8

func _init() -> void:
	set_pitch_scale(randf_range(pitch_min, pitch_max))
	set_bus("SFX")
