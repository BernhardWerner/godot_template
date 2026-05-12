extends Node

const FADE_DURATION := 1.5
const SILENT_DB := -80.0

var _players: Array[AudioStreamPlayer] = []
var _active: int = 0
var _tween: Tween = null
var _pending_stop: AudioStreamPlayer = null


func _ready() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		var idx := AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(idx, "Music")
		AudioServer.set_bus_send(idx, "Master")
	for i in 2:
		var p := AudioStreamPlayer.new()
		p.bus = "Music"
		p.volume_db = 0.0
		add_child(p)
		_players.append(p)
	set_volume(Settings.master_volume)


func set_volume(linear: float) -> void:
	var idx := AudioServer.get_bus_index("Music")
	if idx == -1:
		return
	var db := linear_to_db(linear) if linear > 0.0 else SILENT_DB
	AudioServer.set_bus_volume_db(idx, db)


func play(stream: AudioStream) -> void:
	if stream == null:
		return
	if _players[_active].stream == stream and _players[_active].playing:
		return

	if _tween:
		_tween.kill()
	if _pending_stop:
		_pending_stop.stop()
		_pending_stop = null

	var old_player := _players[_active]
	_active = 1 - _active
	var new_player := _players[_active]

	new_player.stream = stream
	new_player.volume_db = SILENT_DB
	new_player.play()

	_pending_stop = old_player
	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_property(new_player, "volume_db", 0.0, FADE_DURATION)
	_tween.tween_property(old_player, "volume_db", SILENT_DB, FADE_DURATION)
	_tween.finished.connect(func():
		old_player.stop()
		old_player.volume_db = 0.0
		_pending_stop = null
	)
