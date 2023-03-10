extends Node


export var default_setting = {
	"audio_volume_shift": 0,
	"typing_sounds"     : true,
	"always_extra_hints": false,
	"window_maximized"  : true,
	"window_dimensions" : OS.window_size,
	"window_position"   : OS.window_position,
	"keybinds"          : {},
	"current_page"      : 0,
	"score"             : 0,
	"highscore"         : 0,
	"postjam"           : false,
}

export var setting: Dictionary = default_setting.duplicate(true)

const FILEPATH = "user://settings.json"
var file = File.new()

func _ready():
	load_from_file()

	OS.set_window_size(setting.window_dimensions)
	OS.set_window_position(setting.window_position)
	OS.set_window_maximized(setting.window_maximized)

	if (Quit.connect("on_quit", self, "_on_quit") != OK):
		push_error("[Settings] Failed to connect on_quit function")

	if (get_tree().get_root().connect("size_changed", self, "_save_window_values") != OK):
		push_error("[Settings] Failed to connect window size monitor")

	print("Settings Util Loaded: ", setting)

func _on_quit():
	_save_window_values()

func _save_window_values():
	setting.window_dimensions = OS.window_size
	setting.window_maximized  = OS.window_maximized
	setting.window_position   = OS.window_position

	update()

func restore_defaults():
	setting = default_setting.duplicate(true)

func update():
	file.open(FILEPATH, File.WRITE)

	file.store_var(setting)

	file.close()

func load_from_file():
	if (!file.file_exists(FILEPATH)):
		return

	file.open(FILEPATH, file.READ_WRITE)

	var save = file.get_var()

	file.close()

	# Outdated save files will only update current settings that they contain
	for k in save:
		setting[k] = save[k]
