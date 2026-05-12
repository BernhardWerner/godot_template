extends CharacterBody3D
class_name  Player

const SPEED := 6.0
const GRAVITY := -0.1

const FOLLOWER_GAP := 0.7
const FOLLOWER_DAMPING := 72.0
const TRAIL_STEP := 0.03
var _trail : Array[Vector3]

var active := true

var lantern_active := false :
	set(value):
		lantern_active = value
		lantern.visible = value

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var followers: Node3D = $Followers
@onready var interaction_area: Area3D = $InteractionArea
@export var lantern: OmniLight3D




func _unhandled_input(event: InputEvent) -> void:
	if not active or not event.is_action_pressed(&"interact"):
		return
	var closest: InteractibleComponent = null
	var closest_dist := INF
	for area in interaction_area.get_overlapping_areas():
		var component := area.get_parent() as InteractibleComponent
		if component == null or not component.active or component.trigger != InteractibleComponent.TRIGGER.INTERACTION:
			continue
		var dist := global_position.distance_squared_to(component.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = component
	if closest:
		closest.start_interaction()
		get_viewport().set_input_as_handled()


func get_point_along_trail(distance: float) -> Vector3:
	var total := 0.0
	for i : int in _trail.size() - 1:
		var p : Vector3 = _trail[i]
		var q : Vector3 = _trail[i + 1]
		var segment_length = p.distance_to(q)
		if total + segment_length >= distance:
			return lerp(p, q, (distance - total) / segment_length)
		total += segment_length
	return _trail.back()



func _physics_process(delta):
	# Own movement
	if active:
		var input_vector = Input.get_vector(&"move_left", &"move_right", &"move_down",&"move_up")
		
		if input_vector.length() > 0:
			var cam_forward = -camera.global_transform.basis.z
			var cam_right = camera.global_transform.basis.x
			cam_forward.y = 0
			cam_right.y = 0
			cam_forward = cam_forward.normalized()
			cam_right = cam_right.normalized()

			velocity = SPEED * ((cam_forward * input_vector.y) + (cam_right * input_vector.x)) + Vector3(0, velocity.y, 0)
		else:
			velocity = Vector3(0, velocity.y, 0)
		
		velocity.y += GRAVITY
		
		move_and_slide()
	
		# Follower movement
		var max_follower_distance = FOLLOWER_GAP * followers.get_child_count() / TRAIL_STEP
		
		if _trail.is_empty() or _trail[0].distance_to(sprite_3d.global_position) >= TRAIL_STEP:
			_trail.push_front(sprite_3d.global_position)
		_trail = _trail.slice(0, max_follower_distance)
		
		for i : int in followers.get_child_count():
			var follower : Sprite3D = followers.get_child(i)
			var target := get_point_along_trail(FOLLOWER_GAP * (i + 1))
			follower.global_position = lerp(follower.global_position, target, exp(-FOLLOWER_DAMPING * delta))
		
