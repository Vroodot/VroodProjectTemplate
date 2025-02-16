extends Node

# Globals.gd
## Global Node filled with Helper Functions

#region Physics layers
const WORLD_COLLISION_LAYER: int = 1
const PLAYER_COLLISION_LAYER: int = 2
const ENEMIES_COLLISION_LAYER: int = 4
const HITBOXES_COLLISION_LAYER: int = 8
const EXAMPLE_COLLISION_LAYER: int = 16
const INTERACTABLES_COLLISION_LAYER: int = 32
const UNUSED_COLLISION_LAYER: int = 64
const BULLETS_COLLISION_LAYER: int = 128
const ANOTHER_COLLISION_LAYER: int = 256
const THIS_COLLISION_LAYER: int = 512
#endregion

#region Global Variables
var example: int = 1
#endregion

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

#region General Helpers
## Example with lambda -> Utilities.delay_func(func(): print("test"), 1.5)
## Example with arguments -> Utilities.delay_func(print_text.bind("test"), 2.0)
func delay_func(callable: Callable, time: float, deferred: bool = true):
	if callable.is_valid():
		await wait(time)

		if deferred:
			callable.call_deferred()
		else:
			callable.call()

## Example of use: await GameGlobals.wait(1.5)
func wait(seconds: float = 1.0):
	return get_tree().create_timer(seconds).timeout

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused


#endregion

#region Collision Helper
@warning_ignore("narrowing_conversion")
static func collision_layer_to_value(layer: int) -> int:
	if layer > 32:
		push_error("Globals->layer_to_value: The specified collision layer (%d) is invalid. Please ensure the layer value is between 1 and 32" % layer)

	return pow(2, clampi(layer, 1, 32) - 1)

@warning_ignore("narrowing_conversion")
static func value_to_collision_layer(value: int) -> int:
	if value == 1:
		return value

	## This bitwise operation check if the value is a valid base 2
	if value > 0 and (value & (value - 1)) == 0:
		return (log(value) / log(2)) + 1

	push_error("Globals->value_to_layer: The specified value %d) is invalid. Please ensure the value is a power of 2" % value)

	return 0
#endregion
