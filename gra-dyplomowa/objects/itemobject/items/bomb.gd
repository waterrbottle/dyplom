extends Node2D
var display = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if display == true:
		$display.show()
		$object.hide()
		$object.freeze=true
	else:
		$display.hide()
		$object.show()
		$object.freeze=false
