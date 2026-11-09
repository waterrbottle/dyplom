extends CharacterBody2D


const SPEED = 30.0



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0,100) * delta
	if is_on_floor():
		velocity.y=  -200
	move_and_slide()
	velocity.x = 100
