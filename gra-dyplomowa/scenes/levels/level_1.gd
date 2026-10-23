extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$TileMapLayer.material.set_shader_parameter("colorreduceR", randf_range(0.5,30))
	$TileMapLayer.material.set_shader_parameter("colorreduceG", randf_range(0.5,30))
	$TileMapLayer.material.set_shader_parameter("colorreduceB", randf_range(0.5,30))
	$TileMapLayer.material.set_shader_parameter("colorStrength", randf_range(0.9,2.5))
	$Timer.wait_time = randf_range(1,10)
