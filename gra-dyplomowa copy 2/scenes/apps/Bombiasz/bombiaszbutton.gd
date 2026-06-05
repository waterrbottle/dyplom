extends Button
var state = ""
var inmouse = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$fire.hide()
	$water.hide()
	$bomb.hide()
	if state == "water":
		$water.show()
	if state == "fire":
		$fire.show()
	if state == "bomb":
		$bomb.show()
	
		


func _on_area_2d_mouse_entered() -> void:
	inmouse=true


func _on_area_2d_mouse_exited() -> void:
	inmouse=false


func _on_area_2d_area_entered(area: Area2D) -> void:
	inmouse=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	inmouse=false
