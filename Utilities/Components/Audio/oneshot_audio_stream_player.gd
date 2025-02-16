class_name OneShotAudioStreamPlayer
extends AudioStreamPlayer

@export var loops: int = 1

var current_loops: int = 0: set = set_current_loops


func _ready() -> void:
	finished.connect(_on_loop_complete)


func _on_loop_complete() -> void:
	set_current_loops(current_loops + 1)


func set_current_loops(value: int) -> void:
	if value != current_loops:
		current_loops = max(0, value)

		if current_loops >= loops and not is_queued_for_deletion():
			stream = null
			queue_free()
