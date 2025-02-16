extends Node

# References.gd
# Inpsired by Aarimous @ https://youtu.be/KOI0y1OC_tM

# Holds References to Different Resources, Colors, etc
# Helps Avoid Magic Strings and Make Things More Visually Clear

@export_group("Colors")
@export var color_example: Color
@export var color_other: Color

@export_group("Icons")
@export var icon_example: Texture2D
@export var icon_example_outlined: Texture2D

@export_group("Packed Scenes")
@export var level: PackedScene

# TODO Implement with Project Specific Objects
func get_color_by_type(type: Types.EXAMPLE_TYPES) -> Color:
	match type:
		Types.EXAMPLE_TYPES.EXAMPLE:
			return color_example
		Types.EXAMPLE_TYPES.OTHER:
			return color_other
		_:
			return Color.WHITE

# TODO Implement with Project Specific Objects
func get_icon_by_type(type: Types.EXAMPLE_TYPES) -> Texture2D:
	match type:
		Types.EXAMPLE_TYPES:
			return icon_example
		_:
			return icon_example_outlined
