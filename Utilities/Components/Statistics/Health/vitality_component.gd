extends Component
class_name VitalityComponent

signal health_changed(entity, health_current)
signal harmed(entity, damage, damage_type, element_type)
signal invulnerability_toggled(entity, is_invulnerable)
signal has_died(entity)
signal defense_physical_changed(entity, defense_magical)
signal defense_magical_changed(entity, defense_magical)
signal resistance_changed(entity, value, element_type)

@export_group("Health")
@export var health_max: int = 1
@export var health_start: int
var health_current: int:
				set = set_hp, get = get_hp

@export_group("Defense")
@export var defense_physical: int = 0 :
				set = set_physical_defense, get = get_physical_defense
@export var defense_magical: int = 0 :
				set = set_magical_defense, get = get_magical_defense
@export var damage_threshold: int = 0

@export_group("Resistance")
@export var fire_resistance: int = 0
@export var shock_resistance: int = 0
@export var cold_resistance: int = 0
@export var light_resistance: int = 0
@export var dark_resistance :int = 0


@export_group("Invulnerable")
@export var invulnerable: bool = false:
				set = set_invulnerability, get = is_invulnerable
@export var iframe_duration: float ## in seconds

@onready var entity: Node = target

func _ready() -> void:
	set_hp(health_start)

func unalive():
	has_died.emit(entity)


func harm(damage: int, damage_type: Types.DAMAGE, element_type: Types.ELEMENT) -> void:
	if is_invulnerable(): return
	match damage_type:
		Types.DAMAGE.PHYSICAL:
			damage -= defense_physical
		Types.DAMAGE.MAGICAL:
			damage -= defense_magical
	match element_type:
		Types.ELEMENT.FIRE:
			damage -= fire_resistance
		Types.ELEMENT.SHOCK:
			damage -= shock_resistance
		Types.ELEMENT.COLD:
			damage -= cold_resistance
		Types.ELEMENT.LIGHT:
			damage -= light_resistance
		Types.ELEMENT.DARK:
			damage -= dark_resistance
		Types.ELEMENT.NONE:
			return

	if damage <= damage_threshold: return
	harmed.emit(entity, damage, damage_type, element_type)
	set_hp(health_current - damage)


func heal(amount: int) -> void:
	if amount <= 0: return
	set_hp(health_current + amount)

func delay_heal(amount: int, seconds) -> void:
	await Globals.wait(seconds)
	heal(amount)

func start_iframes(seconds: float) -> void:
	set_invulnerability(true)
	await Globals.wait(seconds)
	set_invulnerability(false)


#region Set

func set_invulnerability(value: bool) -> void:
	if value == is_invulnerable(): return
	invulnerable = value
	invulnerability_toggled.emit(entity, invulnerable)


func set_hp(value: int) -> void:
	health_current = clampi(value, 0, health_max)
	health_changed.emit(entity, health_current)
	if health_current <= 0:
		unalive()


func set_resistance(value: int, element_type: Types.ELEMENT) -> void:
	if value <= 0: return
	match element_type:
		Types.ELEMENT.NONE:
			return
		Types.ELEMENT.FIRE:
			fire_resistance = value
		Types.ELEMENT.SHOCK:
			shock_resistance = value
		Types.ELEMENT.COLD:
			cold_resistance = value
		Types.ELEMENT.LIGHT:
			light_resistance = value
		Types.ELEMENT.DARK:
			dark_resistance = value
	resistance_changed.emit(entity, value, element_type)


func set_physical_defense(value: int) -> void:
	if value <= 0: return
	defense_physical = value
	defense_physical_changed.emit(entity, defense_physical)


func set_magical_defense(value: int) -> void:
	if value <= 0: return
	defense_magical = value
	defense_magical_changed.emit(entity, defense_magical)

#endregion



#region Get
func is_invulnerable() -> bool: return invulnerable
func get_hp() -> int: return health_current
func get_physical_defense() -> int: return defense_physical
func get_magical_defense() -> int: return defense_magical
#endregion
