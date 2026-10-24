extends Node2D

var rodpos = Vector2(170,-300)
var rodvel = Vector2(0,0)
var outofbounds = false
# Called when the node enters the scene tree for the first time.
var fishh = load("uid://td8b61o8limk")
func _ready() -> void:
	for i in range(10):
		var inst = fishh.instantiate()
		var position = Vector2( randi_range(0,%minigamebounds.size.x), randi_range(0,%minigamebounds.size.y))
		%fishes.add_child(inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_LEFT):
		if abs(rodvel.x) < 4:
			rodvel.x -= 0.1
	if Input.is_key_pressed(KEY_RIGHT):
		if abs(rodvel.x) < 4:
			rodvel.x += 0.1
	if Input.is_key_pressed(KEY_DOWN):
		if abs(rodvel.y) < 4:
			rodvel.y += 0.05
	if %rodend.global_position.y - %minigamebounds.position.y < 10:
		rodvel.y += 0.1
	
	if %rod.position.x < -5:
		%rod.position.x = 5
	if %rod.position.x >  %minigamebounds.size.x + 5:
		%rod.position.x =  %minigamebounds.size.x - 5
	if %rod.position.x < 0:
		if outofbounds == false:
			rodvel.x *= -1
			outofbounds = true
	else:
		outofbounds=false
	if %rod.position.x > %minigamebounds.size.x:
		if outofbounds == false:
			rodvel.x *= -1
			outofbounds = true
	else:
		outofbounds=false
	if %rodend.global_position.y - %minigamebounds.position.y > %minigamebounds.size.y:
		if outofbounds == false:
			rodvel.y *= -1
			outofbounds = true
	else:
		outofbounds=false
	
	

	
	rodvel.y -= 0.02
	%rod.position += rodvel
	rodvel /= 1.01
	
	
	for n in %fishes.get_children():
		n.baitpos = %rodend.global_position # - $minigamebounds.position
		n.panelpos = %minigamebounds.position


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.queue_free()
