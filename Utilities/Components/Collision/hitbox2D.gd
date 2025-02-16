class_name Hitbox2D
extends Area2D

func _init() -> void:
	collision_mask = 0
	collision_layer = Globals.HITBOXES_COLLISION_LAYER
	monitoring = false
	monitorable = true


func enable() -> void:
	set_deferred("monitorable", true)

func disable() -> void:
	set_deferred("monitorable", false)
