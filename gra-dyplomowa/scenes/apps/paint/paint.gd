extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$paintui/paintui/texture.texture = Image.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
