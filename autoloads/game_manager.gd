extends Node

const VERSION := [0,1,0]





func _ready() -> void:
	load_settings()


func go_to_level(level_key: String, _setup_msg: Dictionary = {}) -> void:
	pass 
	
func go_to_main_menu() -> void:
	pass



func save_to_file(save_data: Dictionary, file_name: String) -> void:
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	var serialized_data := JSON.stringify(JSON.from_native(save_data, true))
	file.store_string(serialized_data)
	file.close()

func load_from_file(file_name: String) -> Dictionary:
	var file := FileAccess.open(file_name, FileAccess.READ)
	if file:
		var data = JSON.to_native(JSON.parse_string(file.get_as_text()), true)
		file.close()
		return data as Dictionary
	return {}


func apply_settings() -> void:
	Settings.apply_volumes()


func save_settings() -> void:
	var data := {
		"master_volume": Settings.master_volume,
		"music_volume":  Settings.music_volume,
		"sfx_volume":    Settings.sfx_volume,
		"rumble":        Settings.rumble,
		"battle_speed":  Settings.battle_speed,
		"text_speed_multiplier":  Settings.text_speed_multiplier,
	}
	save_to_file(data, "user://settings.bs")


func load_settings() -> void:
	var loaded_data := load_from_file("user://settings.bs")
	if not loaded_data.is_empty():
		Settings.master_volume = loaded_data.get("master_volume", 0.5)
		Settings.music_volume  = loaded_data.get("music_volume",  1.0)
		Settings.sfx_volume    = loaded_data.get("sfx_volume",    1.0)
		Settings.rumble        = loaded_data.get("rumble",        0.5)
		Settings.text_speed_multiplier  = loaded_data.get("text_speed_multiplier",  0.5)
		Settings.battle_speed  = loaded_data.get("battle_speed",  1.0)
	apply_settings()
