extends Node2D
@export var entity: CharacterBody2D
var detection_range := 1.0 # How far to look for walls
var modsize := Vector2(35, 35)
var original_size := Vector2(35, 35)
var min_scale := 0.25
var target_scale := Vector2.ONE
var recovery_speed := 5.0
var squash_speed := 20.0
var kill_threshold := 0.1
var is_stuck = false
var stuck_frames = 0
var stuck_threshold := 30
# Called when the node enters the scene tree for the first time.

func _physics_process(delta: float) -> void:
	handle_crush_physics(delta)
	entity.scalemodifier.x = lerp(entity.scalemodifier.x, target_scale.x, squash_speed * delta)
	entity.scalemodifier.y = lerp(entity.scalemodifier.y, target_scale.y, squash_speed * delta)
	check_if_stuck()

func handle_crush_physics(delta: float):
	# 1. Check Horizontal (Left/Right)
	var dist_l = get_distance_to_wall(Vector2.LEFT)
	var dist_r = get_distance_to_wall(Vector2.RIGHT)
	if dist_l != -1.0 and dist_r != -1.0:
		var total_gap = dist_l + dist_r
		if total_gap < original_size.x:
			target_scale.x = max(total_gap / original_size.x, min_scale)
			target_scale.y = 1/max(total_gap / original_size.x, min_scale)
			# Reposition to stay perfectly centered between the two walls
			var offset = (dist_r - dist_l) / 2.0
			global_position.x += offset
	else:
		target_scale.x = move_toward(target_scale.x, 1.0, target_scale.y)

	# 2. Check Vertical (Up/Down)
	var dist_u = get_distance_to_wall(Vector2.UP)
	var dist_d = get_distance_to_wall(Vector2.DOWN)
	
	if dist_u != -1.0 and dist_d != -1.0:
		var total_gap = dist_u + dist_d
		if total_gap < original_size.y:
			target_scale.y = max(total_gap / original_size.y, min_scale)
			target_scale.x = 1/max(total_gap / original_size.y, min_scale)
			var offset = (dist_d - dist_u) / 2.0
			global_position.y += offset
	else:
		target_scale.y = move_toward(target_scale.y, 1.0, recovery_speed * delta)

func get_distance_to_wall(direction: Vector2) -> float:
	var space_state = get_world_2d().direct_space_state
	
	# We use a ShapeQuery to detect walls as a "block" rather than a thin line
	var query = PhysicsShapeQueryParameters2D.new()
	
	# Use a small rectangle as the sensor
	var sensor_shape = RectangleShape2D.new()
	sensor_shape.size = Vector2(4, 4) # Small probe size
	
	query.shape = sensor_shape
	query.collision_mask = entity.collision_mask # Use the same layers the player hits
	query.exclude = [entity.get_rid()]           # Don't hit ourselves
	
	# Cast the shape out in the chosen direction
	var cast_distance = original_size.x # Look far enough to find opposing walls
	query.transform = entity.global_transform
	query.motion = direction * cast_distance
	
	var result = space_state.cast_motion(query)
	
	# result[0] is the safe fraction (0.0 to 1.0) before hitting a wall
	if result[0] < 1.0:
		return result[0] * cast_distance

	return -1.0 # No wall found within range

func check_if_stuck():
	# 1. Check if the scale is too small (meaning walls have physically crushed us)

	if target_scale.x <= kill_threshold or target_scale.y <= kill_threshold:
		print("ded")
		on_crushed()
		return

	var is_currently_overlapping = entity.test_move(entity.global_transform, Vector2.ZERO)
	
	if is_currently_overlapping:
		stuck_frames += 1
	else:
		stuck_frames = 0
	
	# Only set is_stuck to true if it persists
	if stuck_frames >= stuck_threshold:
		if not is_stuck:
			is_stuck = true
			entity.die()
			print("Definitely Stuck")
	else:
		if is_stuck:
			is_stuck = false
			print("Escaped")

func on_crushed():
	# Replace this with your game over logic
	# print("CRUSHED!")
	entity.die()
	pass
