extends Node


var master_volume: float = 0.5
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var rumble: float = 1.0            
var text_speed_multiplier: float = 0.5     
var battle_speed: float = 1.0      


func apply_volumes() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),  linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),    linear_to_db(sfx_volume))
