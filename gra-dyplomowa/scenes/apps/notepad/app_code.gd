extends Node2D
var content = ["",false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AppCode/ColorRect/TextEdit.text = content[0]
	if content[1] == true:
		$AppCode/Panel.show()
		$AppCode/ColorRect/TextEdit.editable=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
