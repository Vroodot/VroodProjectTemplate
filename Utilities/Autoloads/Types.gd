extends Node

# Types.gd
## Autoload used for defining types through Enums

enum EXAMPLE_TYPES {EXAMPLE, OTHER}


# Math Based Types
enum RESULT {SUM, HIGHEST, LOWEST, AVERAGE}

# Damage Types
enum DAMAGE {PHYSICAL, MAGICAL}

enum ELEMENT {FIRE, SHOCK, COLD, LIGHT, DARK, NONE}

func random_type_from_enum(_enum):
	return _enum.keys()[Random.randi() % _enum.size()]
