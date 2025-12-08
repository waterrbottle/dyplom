extends CharacterBody2D

var canjump = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	print(Global.playervars["position"].y)
	if is_on_floor():
		
		#print(Global.playervars["position"].y)
		if position.y > Global.playervars["position"].y + 30:
			print("duh")
			velocity.y = -700

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	$ColorRect.color = Color(randf_range(0.5,1), 0.3, 0.3)
	if position.x > Global.playervars["position"].x:
		velocity.x += -5
	else:
		velocity.x += 5
	
	if abs(velocity.x) > 500:
		velocity.x /= 1.1
	
	velocity.y += 30# += get_gravity() * 3
	if canjump == true:
		if is_on_floor():
			if position.y > Global.playervars["position"].y + 30:
				$Timer.wait_time= randf_range(0.5,1.5)
				if $Timer.time_left == 0.0:
					print("hi")
				
					$Timer.start()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.active==true:
			body.damage(5)
