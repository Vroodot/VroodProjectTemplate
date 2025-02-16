extends Node
class_name Component

@export var target: Node

func _ready() -> void:
	if !target:
		target = get_parent()
	self.add_to_group("Components")
