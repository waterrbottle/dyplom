extends CharacterBody2D

var canjump = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$ColorRect.color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1.0)
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
				velocity.y = -1000
	move_and_slide()
