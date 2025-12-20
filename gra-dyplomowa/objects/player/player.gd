extends CharacterBody2D


const SPEED = 25.0
const JUMP_VELOCITY = -900.0
var walkspeed = 0
var velocityhist := 0.0
var wallfever = false
var active = true
var particlescene = load("res://objects/player/playerspawnpart.tscn")

#fighting vars
var fight = false
var fightdir = 0
var fightdirmem = 0

func _process(delta: float) -> void:
	
	if active == false:
		return
	if Input.is_action_pressed("fight"):
		
		if fight == false:
			$fight.show()
			%fistobject.active = true
			%fistobject.dir = fightdir
			%fistobject.bodyvel = velocity
			$fight.rotation_degrees = 90 * fightdir - 90
			$fight/fight_anim.play("fight")
		fight = true
	
	
func _physics_process(delta: float) -> void:

	
	if active == true:
		Global.playervars["position"] = global_position
		if is_on_wall():
			if !is_on_floor():
				if Input.is_key_pressed(KEY_SPACE):
					wallfever = true
					$GPUParticles2D.emitting = true
	
					if abs(velocityhist) > 10:
						velocity.y=0
						if abs(velocityhist) > 2000:
							velocityhist /= 2
						velocity.y += abs(velocityhist)*-0.5
						velocity.x = velocityhist *-1.2
	if active == true:
		if !Input.is_key_pressed(KEY_SPACE) or abs(velocity.x) < 20 or is_on_floor():
			$GPUParticles2D.emitting = false
			if wallfever ==true:
				wallfever = false
				velocity.x/=5
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta * 3

	# Handle jump.
	if active == true:
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
		var direction := Input.get_axis("left", "right")
		if not direction == 0:
			fightdir = direction
			fightdirmem = fightdir
		if Input.is_action_just_pressed("left"):
			velocity.x = abs(velocity.x) * -0.4
			walkspeed = abs(velocity.x) * -0.4
		if Input.is_action_just_pressed("right"):
			velocity.x = abs(velocity.x) * 0.4
			walkspeed = abs(velocity.x) * 0.4
		if direction:
			if abs(walkspeed) < 1500:
				if wallfever == false:
					velocity.x += direction * SPEED

		else:

			if !Input.is_key_pressed(KEY_SPACE) and wallfever == true:
				velocity.x = move_toward(velocity.x, 0, SPEED*3)
			if wallfever == false:
				velocity.x = move_toward(velocity.x, 0, SPEED*3)
		velocityhist = velocity.x

		
		
	if active == true:
		move_and_slide()
		$SubViewport/Node3D.show()
		$fight.show()
	else:
		$fight.hide()
		$SubViewport/Node3D.hide()
	


	$AnimationTree.set("parameters/blend_position", velocity.x)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "run":
		
		if abs(velocity.x) < 1:
			pass
	
	

 
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
