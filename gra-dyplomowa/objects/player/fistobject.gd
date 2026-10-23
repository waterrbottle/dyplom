extends Area2D
var active = false
var dir = 0
var bodyvel = Vector2(0,0)
var cooldown = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if active == false:
		set_collision_layer_value(5, false)
		set_collision_mask_value(5, false)
	else:
		if cooldown == true:
			set_collision_mask_value(5, false)
			set_collision_layer_value(5, false)
		else:
			set_collision_mask_value(5, true)
			set_collision_layer_value(5, true)
		#%fistobject.monitorable=true


func _on_fight_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fight":

		cooldown = true
		$cooldown.start()



func _on_cooldown_timeout() -> void:
	
	cooldown=false
	active=false
