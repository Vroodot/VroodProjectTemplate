class_name Hurtbox2D
extends Area2D




func _init() -> void:
	monitoring = true
	monitorable = false
	collision_mask = Globals.HITBOXES_COLLISION_LAYER


func _ready() -> void:
	area_entered.connect(on_area_entered)


func enable() -> void:
	set_deferred("monitoring", true)


func disable() -> void:
	set_deferred("monitoring", false)


func on_area_entered(hitbox: Area2D) -> void:
	if hitbox is not Hitbox2D: return
	Events.hitbox_detected.emit(hitbox)
