extends Node2D
var panelpos = Vector2(0,0)
var velocity = Vector2(0,0)
var baitpos = Vector2(0,0)
var speed = 500.0        # Top speed
var acceleration = 5000.0 # How fast it reaches top speed
var friction = 15000.0
var randcord = Vector2(0,0)
var min_x = 0
var max_x = 400
var min_y = 0
var max_y = 400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randcord = Vector2(randi_range(20,380), randi_range(20,380))
	speed = randi_range(100,400)
	acceleration = randi_range(3000,6000)
	friction = randi_range(1500,15000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (baitpos - global_position) * -1
	var distance = direction.length()
	
	if distance <  100:
		# Move toward the target
		direction = direction.normalized()
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		# Stop quickly when close enough
		velocity = velocity.move_toward( (randcord - global_position), friction * delta)
	position += velocity * delta
	var margin = 10
	if position.x > max_x:
		position.x = min_x + margin
	elif position.x < min_x:
		position.x = max_x - margin
	if position.y > max_y:
		position.y = min_y + margin
	elif position.y < min_y:
		position.y = max_y - margin


func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(0.5,5)
	randcord = Vector2(randi_range(10,390), randi_range(10,390)) + panelpos
