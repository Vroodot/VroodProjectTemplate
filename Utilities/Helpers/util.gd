class_name Util
extends RefCounted

static func set_flags(value: bool, flags: Array[bool]) -> void:
	for flag in flags:
		flag = value

static func toggle_flags(flags: Array[bool]) -> void:
	for flag in flags:
		flag = !flag
