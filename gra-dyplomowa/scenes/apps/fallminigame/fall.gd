extends Node2D
var b = null
var active = true
var running = false
var tp = false
var ballsleft = 5
var inside = false
var timer = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody2D.freeze=true
	$RigidBody2D.contact_monitor=true
	for i in range(5):
		b = $wall.duplicate()
		b.position = Vector2(randi_range(0,300),randi_range(100,400))
		b.rotation_degrees = randi_range(-5,5)
		b.show()
		$walls.add_child(b)
		
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	inside = false
	if get_viewport().get_mouse_position().x > 0 and get_viewport().get_mouse_position().x < $Leveldata.scenesize.x:
		if get_viewport().get_mouse_position().y > 0 and get_viewport().get_mouse_position().y < $Leveldata.scenesize.y:
			inside = true
	$Label.text = "balls left: " + str(ballsleft)
	$Label2.text = "timer left: " + str(floor(timer*10)/10)
	if Input.is_action_just_pressed("click"):
		if get_viewport().get_mouse_position().y < 400:
			if ballsleft > 0:
				if inside == true:
					if running == false:
						ballsleft -= 1
						var bb = $balllol.duplicate()
						bb.position = get_viewport().get_mouse_position()
						bb.show()
						$balls.add_child(bb)
	if running == true:
		if timer >= 0:
			timer -= delta
	if timer <= 0:
		if running == true:
			$ColorRect2.color = Color(1.0, 0.34, 0.34, 1.0)
			$CanvasLayer/ColorRect/Label3.text = "you run out of time!"
			$ColorRect2/AnimationPlayer.play("infobar")
			teleport_body( Vector2(150,20))
			$Timer.start()
		running=false
		$RigidBody2D.freeze=true
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			pass
func teleport_body(new_pos: Vector2):
	PhysicsServer2D.body_set_state(
		$RigidBody2D.get_rid(), 
		PhysicsServer2D.BODY_STATE_TRANSFORM, 
		Transform2D(0, new_pos)
	)

func _on_button_pressed() -> void:
	if running == true:
		
		$ColorRect2.color = Color(1.0, 0.34, 0.34, 1.0)
		$CanvasLayer/ColorRect/Label3.text = "you lost 5 hp!"
		$ColorRect2/AnimationPlayer.play("infobar")
		$Timer.start()
		
		return
	else:
		
		running = true
		$RigidBody2D.freeze=false
		$Button.text = "reset"
		


func resetgame():
	$Button.text = "FALL!"
	running=false
	$RigidBody2D.freeze=true
	teleport_body( Vector2(150,20))
	ballsleft=5
	timer=20
	for c in $balls.get_children():
		c.queue_free()
	for c in $walls.get_children():
		c.queue_free()
	for i in range(5):
		b = $wall.duplicate()
		b.position = Vector2(randi_range(0,300),randi_range(100,400))
		b.rotation_degrees = randi_range(-5,5)
		b.show()
		$walls.add_child(b)
	
	
	
func _on_a_1_body_entered(body: Node2D) -> void:
	$ColorRect2.color = Color(1.0, 0.34, 0.34, 1.0)
	$CanvasLayer/ColorRect/Label3.text = "you lost 5 hp!"
	$ColorRect2/AnimationPlayer.play("infobar")

	$Timer.start()


func _on_a_2_body_entered(body: Node2D) -> void:
	$ColorRect2.color = Color(0.214, 0.63, 0.242, 1.0)
	$CanvasLayer/ColorRect/Label3.text = "you are now smaller!"
	$ColorRect2/AnimationPlayer.play("infobar")
	Global.playervars["scale"] += Vector2(-0.5, -0.5)
	$Timer.start()


func _on_a_3_body_entered(body: Node2D) -> void:
	$ColorRect2.color = Color(0.214, 0.63, 0.242, 1.0)
	$CanvasLayer/ColorRect/Label3.text = "you are now BIGER!"
	$ColorRect2/AnimationPlayer.play("infobar")
	Global.playervars["scale"] += Vector2(+0.5, +0.5)
	$Timer.start()


func _on_a_4_body_entered(body: Node2D) -> void:
	$ColorRect2.color = Color(1.0, 0.34, 0.34, 1.0)
	$CanvasLayer/ColorRect/Label3.text = "you lost 5 hp!"
	$ColorRect2/AnimationPlayer.play("infobar")


	$Timer.start()




func _on_timer_timeout() -> void:
	resetgame()
