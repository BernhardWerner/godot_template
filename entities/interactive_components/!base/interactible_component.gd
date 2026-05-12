@icon("res://assets/icons/hand-pointing-blue.svg")
extends Node3D
class_name InteractibleComponent

enum TRIGGER { NONE, AREA_ENTERED, INTERACTION }

enum WHEN_FINISHED { NOTHING, DEACTIVATE, DELETE_SELF, DELETE_PARENT }

enum DATA_REQUEST { NONE, UPDATE_LEDGER, SAVE_GAME }

@export var active := true
@export var trigger : TRIGGER
@export var inventory_check : Array[ItemRequirement]
@export var when_finished : WHEN_FINISHED
@export var data_request : DATA_REQUEST
@export var path_to_follow_up_interaction : NodePath


var _running := false

signal interaction_started(component: InteractibleComponent)
signal interaction_finished(component: InteractibleComponent)
signal ledger_entry_requested
signal save_requested


@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D


func _unhandled_input(event: InputEvent) -> void:
	pass

func has_player_items() -> bool:
	return GameManager.has_items(inventory_check)

func start_interaction() -> void:
	if has_player_items():
		_running = true
		interaction_started.emit(self)

func finish_interaction() -> void:
	_running = false
	interaction_finished.emit(self)
	if path_to_follow_up_interaction:
		get_node(path_to_follow_up_interaction).start_interaction()
	var deleting := when_finished in [WHEN_FINISHED.DELETE_SELF, WHEN_FINISHED.DELETE_PARENT]
	match when_finished:
		WHEN_FINISHED.NOTHING:
			pass
		WHEN_FINISHED.DEACTIVATE:
			active = false
		WHEN_FINISHED.DELETE_SELF:
			queue_free()
		WHEN_FINISHED.DELETE_PARENT:
			get_parent().queue_free()
	match data_request:
		DATA_REQUEST.NONE:
			pass
		DATA_REQUEST.UPDATE_LEDGER:
			if deleting:
				ledger_entry_requested.emit.call_deferred()
			else:
				ledger_entry_requested.emit()
		DATA_REQUEST.SAVE_GAME:
			save_requested.emit()

func _ready() -> void:
	interaction_started.connect(EventBus._on_interaction_started)
	interaction_finished.connect(EventBus._on_interaction_finished)
	ledger_entry_requested.connect(EventBus._on_ledger_update_requested)
	save_requested.connect(EventBus._on_save_requested)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if active and trigger == TRIGGER.AREA_ENTERED and body is Player:
		start_interaction()
