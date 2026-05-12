class_name TutorialMenu extends Control

signal tutorial_closed

@onready var tab_container: TabContainer = $MarginContainer/VBoxContainer/TabContainer


func open() -> void:
	show()

func _on_back_button_pressed() -> void:
	hide()
	tutorial_closed.emit()
