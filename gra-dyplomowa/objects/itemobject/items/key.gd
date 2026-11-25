extends Node2D
var display = true
var active = true
var used = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func spawn(vel):
	$object.position = Vector2(0,0)
	$object.freeze=false
	display=false
	if vel.y> 0:
		vel.y *= -0.5
	$object.apply_central_impulse(vel)

func _physics_process(delta: float) -> void:
	if $object.linear_velocity.length() > 1000:
		$object.linear_velocity /= 1.1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if display == true:
		$display.show()
		$object.hide()
		$object.freeze=true
		$object.position=Vector2(0,0)
	else:
		
		$display.hide()
		$object.show()
		$object.freeze=false
	


func _on_object_body_entered(body: Node) -> void:

	if display == false:

		if body.is_in_group("player"):
			print("key picked up")
			
			if Global.item == "":
				print("key picked up")
				queue_free()
				Global.add_item("key")
