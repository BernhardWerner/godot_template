extends Control

@export var bgm: AudioStream


func _ready() -> void:
	MusicManager.play(bgm)
	SceneTransition.jump_to_black()
	SceneTransition.fade_to_transparent()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneTransition.jump_to_white()
	await get_tree().process_frame
	GameManager.go_to_main_menu()
