extends Node

# Types.gd
## Autoload used for defining types through Enums

enum EXAMPLE_TYPES {EXAMPLE, OTHER}


# Random Types
enum RESULT {SUM, HIGHEST, LOWEST, AVERAGE}



func random_type_from_enum(_enum):
	return _enum.keys()[Random.randi() % _enum.size()]
