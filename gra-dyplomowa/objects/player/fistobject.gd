extends Area2D
var active = false
var dir = 0
var bodyvel = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if active == false:
		set_collision_layer_value(5, false)
		set_collision_mask_value(5, false)
	else:
		set_collision_mask_value(5, true)
		set_collision_layer_value(5, true)
		
