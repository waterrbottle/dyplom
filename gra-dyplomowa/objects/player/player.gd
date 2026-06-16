extends CharacterBody2D


const SPEED = 15.0
const JUMP_VELOCITY = -1000.0
var walkspeed = 0
var velocityhist := 0.0
var wallfever = false
var active = true
var particlescene = load("res://objects/player/playerspawnpart.tscn")

#fighting vars
var fight = false
var fightdir = 0
var fightdirmem = 0
@export var desktop = false
var startpos := Vector2(0,0)
var scalemodifier = Vector2(1,1)
@export var detection_range := 1.0 # How far to look for walls
var modsize := Vector2(35, 35)
@export var original_size := Vector2(35, 35)
@export var min_scale := 0.25
var target_scale := Vector2.ONE
@export var recovery_speed := 5.0
@export var squash_speed := 20.0
@export var kill_threshold := 0.1
var is_stuck = false
var stuck_frames = 0
var sneak = false
@export var stuck_threshold := 30
var floordash = 0
func _ready() -> void:
	if desktop==true:
		$Camera2D.enabled=false
	startpos=position
	if Global.item != "":
		add_item(Global.item)

func add_item(id):
	$Itemhold.itemid = id
	$Itemhold.load_item()

func _process(delta: float) -> void:

	$Itemhold.hide()
	if active == false:
		set_collision_layer_value(1,false)
		set_collision_mask_value(3,false)
		return
	set_collision_mask_value(3,true)
	set_collision_layer_value(1,true)
	$Itemhold.show()
	scale = scalemodifier + (Global.playervars["scale"] - Vector2(1,1))
	if desktop == true:
		if position.x<0:
			die()

		if position.x > get_viewport_rect().size.x:
			die()
		if position.y > get_viewport_rect().size.y:
			die()
		if position.y < 0:
			die()
	
	var canfight = true
	
	if Input.is_action_pressed("fight"):
		if Global.item != "":
			Global.item = ""
			canfight=true
			if get_parent() != null:
				var i = $Itemhold.get_node("item").get_child(0).duplicate()
				i.position = global_position + Vector2(0,-30)# + Vector2(0,50)
				i.display = false
				

				i.spawn(Vector2(velocity.x * 2,velocity.y -300))
				Global.add_item("")
				$Itemhold.get_node("item").get_child(0).queue_free()
				
				if get_parent().has_node("objects"):
					get_parent().get_node("objects").add_child(i)
				else:
					get_parent().add_child(i)
					print("no object node to add the object to!")
				
		
		if fight == false:
			if canfight == true:
				print("FIGHT!")
				$fight.show()
				%fistobject.active = true
				%fistobject.dir = fightdir
				%fistobject.bodyvel = velocity
				$fight.rotation_degrees = 90 * fightdir - 90
				$fight/fight_anim.play("fight")
		fight = true
	
	
	
	for n in $dasparticles.get_children():
		if n.emitting == false:
			
			n.queue_free()
	
	if abs(velocity.x) > 30:
		if is_on_floor():
			if Input.is_action_pressed("down"):
				sneak = true
			else:
				sneak = false
			
	else:
		sneak=false
	if sneak == true:
		if not is_on_floor():
			if Input.is_action_pressed("down"):
				sneak=true
			else:
				sneak=false
			if Input.is_action_pressed("jump"):
				sneak = false

			
			


	
func _physics_process(delta: float) -> void:
	#Global.playervars["scale"] = Vector2(2,2)
	if active == true:
		original_size = modsize * Global.playervars["scale"] * 1
		detection_range = Global.playervars["scale"].x
		Global.playervars["position"] = global_position
		if is_on_wall():
			if !is_on_floor():
				if Input.is_key_pressed(KEY_SPACE):
					wallfever = true
					$GPUParticles2D.emitting = true
	
					if abs(velocityhist) > 10:
						
						velocity.y=0
						if abs(velocityhist) > 1000:
							velocityhist /= 1.5

						velocity.y += abs(velocityhist)*-1.0

						velocity.x = velocityhist *-1.5 - 10
	
	if active == true:
		if Global.lockinput==false:
			
			
			if Input.is_action_pressed("down"):
				if sneak == false:
					if not is_on_floor():
						velocity.y+=100
						velocity.x/=1.5
						floordash = 1
					if is_on_floor():
						if floordash == 1:
							floordasparticle()
							floordash=0
					

		
			if !Input.is_key_pressed(KEY_SPACE) or abs(velocity.x) < 20 or is_on_floor():
				$GPUParticles2D.emitting = false
				if wallfever ==true:
					wallfever = false
					if Input.is_action_pressed("left") and velocity.x > 0:
						velocity.x/=5
					if Input.is_action_pressed("right") and velocity.x < 0:
						velocity.x/=5
					if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
						velocity.x/=1.1
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta * 3

	# Handle jump.
	if active == true:
		if Global.lockinput==false:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
	if not is_on_floor() and velocity.y < 0:
		fightdir = 0
	if not is_on_floor() and velocity.y > 0:
		fightdir = 2
	if is_on_floor():
		fightdir=fightdirmem

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if active == true:
		if Global.lockinput==false:
			var direction := Input.get_axis("left", "right")
			if not direction == 0:
				fightdir = direction
				fightdirmem = fightdir
			if sneak == false:
				if velocity.x>10:
					if Input.is_action_just_pressed("left"):
						velocity.x = abs(velocity.x) * -0.1
						walkspeed = abs(velocity.x) * -0.1
				if velocity.x<-10:
					if Input.is_action_just_pressed("right"):
						velocity.x = abs(velocity.x) * 0.1
						walkspeed = abs(velocity.x) * 0.1
			if direction:
				if abs(velocity.x) < 1000:
					if wallfever == false:
						velocity.x += direction * SPEED
			


			else:

				if !Input.is_key_pressed(KEY_SPACE) and wallfever == true:
					velocity.x = move_toward(velocity.x, 0, SPEED*3)
				if wallfever == false:
					if sneak == false:
						velocity.x = move_toward(velocity.x, 0, SPEED*3)
			velocityhist = velocity.x
	
	$sprintparticle.emitting=false
	if is_on_floor():
		if abs(velocity.x) > 20:
			$sprintparticle.emitting=true
		
	
	if active == true:
		move_and_slide()
		$SubViewport/Node3D.show()
		$fight.show()
	else:
		$fight.hide()
		$SubViewport/Node3D.hide()
	
	handle_crush_physics(delta)
	
	# Smoothly apply the scale changes
	scalemodifier.x = lerp(scalemodifier.x, target_scale.x, squash_speed * delta)
	scalemodifier.y = lerp(scalemodifier.y, target_scale.y, squash_speed * delta)
	check_if_stuck()

	$AnimationTree.set("parameters/blend_position", velocity.x)
	$AnimationTree.set("parameters/BlendSpace1D/blend_position", velocity.x)



func floordasparticle():
	var i = $dashparticle.duplicate()
	i.emitting = true
	i.visible = true
	$dasparticles.add_child(i)
	print("DASHEMD")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "run":
		
		if abs(velocity.x) < 1:
			pass
	
	

func die():
	var inst = particlescene.instantiate()
	inst.emitting = true
	inst.position = global_position
	inst.top_level=true
	add_child(inst)
	$GPUParticles2D.emitting=false
	wallfever = false
	#$AnimationPlayer.play("despawn")
	call_deferred("set_position", startpos)
	target_scale = Vector2(1,1)
 
func despawn():
	active = false
	$AnimationPlayer.play("despawn")
	wallfever = false
	$GPUParticles2D.emitting=false
	var inst = particlescene.instantiate()
	inst.emitting = true
	add_child(inst)
	
func spawn():
	active = true
	$AnimationPlayer.play_backwards("despawn")
	var inst = particlescene.instantiate()
	inst.emitting = true
	#add_child(inst)

func damage(amount: int):
	velocity.x = -500
	velocity.y = -500
	Global.playervars["health"] -= amount


func _on_fight_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fight":
		fight = false
		$fight.hide()
		%fistobject.active = false


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
	query.collision_mask = collision_mask # Use the same layers the player hits
	query.exclude = [get_rid()]           # Don't hit ourselves
	
	# Cast the shape out in the chosen direction
	var cast_distance = original_size.x # Look far enough to find opposing walls
	query.transform = global_transform
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

	var is_currently_overlapping = test_move(global_transform, Vector2.ZERO)
	
	if is_currently_overlapping:
		stuck_frames += 1
	else:
		stuck_frames = 0
	
	# Only set is_stuck to true if it persists
	if stuck_frames >= stuck_threshold:
		if not is_stuck:
			is_stuck = true
			die()
			print("Definitely Stuck")
	else:
		if is_stuck:
			is_stuck = false
			print("Escaped")

func on_crushed():
	# Replace this with your game over logic
	# print("CRUSHED!")
	die()
	pass
