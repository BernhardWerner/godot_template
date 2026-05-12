class_name SettingsMenu extends Control

signal settings_closed

@onready var tab_container: TabContainer = $MarginContainer/VBoxContainer/TabContainer
@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/Sound/GridContainer/MasterSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/Sound/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/Sound/GridContainer/SFXslider
@onready var rumble_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/Gameplay/GridContainer/RumbleSlider
@onready var text_speed_slider: HSlider = $MarginContainer/VBoxContainer/TabContainer/Gameplay/GridContainer/TextSpeedSlider
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton



func open(show_assist: bool = false) -> void:
	tab_container.set_tab_hidden(3, not show_assist)
	master_slider.value = Settings.master_volume
	music_slider.value  = Settings.music_volume 
	sfx_slider.value    = Settings.sfx_volume   
	rumble_slider.value = Settings.rumble       
	text_speed_slider.value = Settings.text_speed_multiplier
	show()


func _on_master_slider_value_changed(value: float) -> void:
	Settings.master_volume = value
	Settings.apply_volumes()
	GameManager.save_settings()


func _on_music_slider_value_changed(value: float) -> void:
	Settings.music_volume = value
	Settings.apply_volumes()
	GameManager.save_settings()


func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	Settings.apply_volumes()
	GameManager.save_settings()

func _on_rumble_slider_value_changed(value: float) -> void:
	Settings.rumble = value
	Input.start_joy_vibration(0, 0.5 * Settings.rumble, 1.0 * Settings.rumble, 0.6)
	GameManager.save_settings()

func _on_back_button_pressed() -> void:
	GameManager.save_settings()
	hide()
	settings_closed.emit()


func _on_text_speed_slider_value_changed(value: float) -> void:
	Settings.text_speed_multiplier = value
	GameManager.save_settings()
