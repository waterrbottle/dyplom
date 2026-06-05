extends Node

var content = "computer exploded"
var bug = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bug == true:
		$CanvasLayer/ColorRect.color = Color(1.0, 0.43, 0.43, 1.0)
	$CanvasLayer/Label.text = content
	get_parent().get_parent().get_parent().updatesize(Vector2($CanvasLayer/Label.size.x + 30, 100))


func _on_button_pressed() -> void:
	get_parent().get_parent().get_parent().queue_free()
