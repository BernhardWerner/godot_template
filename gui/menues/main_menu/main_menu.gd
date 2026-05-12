class_name MainMenu extends Control

@onready var background: ColorRect = $Background
@onready var version_label: Label = $Background/ButtonPanel/VersionLabel
@onready var title: Label = $Background/ButtonPanel/Title

@onready var button_panel: Control = $Background/ButtonPanel
@onready var button_container: GridContainer = $Background/ButtonPanel/ButtonContainer
@onready var settings_button: Button = $Background/ButtonPanel/ButtonContainer/SettingsButton
@onready var tutorial_button: Button = $Background/ButtonPanel/ButtonContainer/TutorialButton
@onready var credits_button: Button = $Background/ButtonPanel/ButtonContainer/CreditsButton


@onready var settings_menu: SettingsMenu = $Background/SettingsMenu

@onready var tutorial_menu: TutorialMenu = $Background/TutorialMenu

@onready var credits: Control = $Background/Credits
@onready var credits_back_button: Button = $Background/Credits/MarginContainer/VBoxContainer/CreditsBackButton




func _ready() -> void:
	version_label.text = "Version %s.%s.%s" % GameManager.VERSION
	background.color = GameManager.MENU_COLOR
	button_container.get_child(0).grab_focus()
	
	# Silly nonsense; REMOVE
	title.text = [
		"Dungeon Regular",
		"The Deep Door",
		"The Sundered Isle"
	].pick_random()


func _on_new_game_pressed() -> void:
	SceneTransition.fade_to_black(1.5)
	await SceneTransition.finished
	GameManager.go_to_level("town", {
		"fade_in": 1.5
	})


func _on_load_game_pressed() -> void:
	pass


func _on_settings_pressed() -> void:
	button_panel.hide()
	settings_menu.open()
	settings_menu.tab_container.get_tab_bar().grab_focus()
	await settings_menu.settings_closed
	button_panel.show()
	settings_button.grab_focus()


func _on_tutorial_pressed() -> void:
	button_panel.hide()
	tutorial_menu.open()
	tutorial_menu.tab_container.get_tab_bar().grab_focus()
	await tutorial_menu.tutorial_closed
	button_panel.show()
	tutorial_button.grab_focus()



func _on_credits_pressed() -> void:
	button_panel.hide()
	credits.show()
	credits_back_button.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_back_button_pressed() -> void:
	credits.hide()
	button_panel.show()
	credits_button.grab_focus()
