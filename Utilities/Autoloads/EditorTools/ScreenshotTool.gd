extends Node
# ScreenshotTool.gd

## Saves multiple screenshots per debug session
## Will save over previous screenshot upon startup

@export var screenshot_directory: String = "E:/Warehouse/Screenshots/"
var counter: int

func _ready() -> void:
	# Tool will work even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(_event: InputEvent) -> void:
	debug_screenshot()


func debug_screenshot() -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("screenshot"):
		var image: Image = get_viewport().get_texture().get_image()
		var file_name: String = screenshot_directory + str(counter) + "new_image.png"
		counter += 1
		image.save_png(file_name)
