extends Node2D
var display = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn(vel):
	$object.freeze=false
	display=false
	$object.apply_central_impulse(vel)

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
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if display == false:
		
		
		
		for n in $tilecheck.get_overlapping_bodies():
			
			if n is TileMapLayer:
		
				var o = n.get_used_cells()
				for a in o:

					
					if position.distance_to(a * 32) < 200:
						if n.get_cell_source_id(a) == 0:
							n.set_cell(a, -1, Vector2(0,0))
						
						
						
		$object/display.hide()
		$object.call_deferred("set_freeze_enabled", true)

		for n in $object/EXPLODE.get_children():
			n.emitting=true
			
		
		await get_tree().create_timer(5).timeout
		queue_free()
