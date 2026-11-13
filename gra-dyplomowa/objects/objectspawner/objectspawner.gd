extends Control

@export var object: PackedScene
@export var timeBetweenSpawns = Vector2(1.0,2.0)
@export var objectlimit := 30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$editor.hide()
	self_modulate = Color(0.0, 0.0, 0.0, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if object == null:
		return
	if timeBetweenSpawns == null:
		return
	if objectlimit >= 0:
		if $spawnedobjects.get_child_count() >= objectlimit:
			return
	var inst = object.instantiate()
	inst.position.x = randf_range(global_position.x,global_position.x + size.x)
	inst.position.y = randf_range(global_position.y,global_position.y + size.y)
	$spawnedobjects.add_child(inst)
	$Timer.wait_time = randf_range(timeBetweenSpawns.x, timeBetweenSpawns.y)
