@icon("res://assets/icons/hand-coins-blue.svg")
extends InteractibleComponent
class_name ItemCollectComponent

@export var item: Item
@export var quantity := 1


func start_interaction() -> void:
	super()
	if _running:
		GameManager.add_item(item.id, quantity)
		finish_interaction()
