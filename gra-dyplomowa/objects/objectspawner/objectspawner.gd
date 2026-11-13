extends Control

@export var object: PackedScene
@export var timeBetweenSpawns = Vector2(1.0,2.0)
@export var objectlimit := 30
@export_category("copy object = use editable children and give copier a node")

@export var copyExistingObject := false
var copiedobj = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if copyExistingObject == true:
		if $COPIER.get_child_count() > 0:
			copiedobj = $COPIER.get_child(0).duplicate()
			for n in $COPIER.get_children():
				n.queue_free()
	$editor.hide()
	self_modulate = Color(0.0, 0.0, 0.0, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if copyExistingObject == false:
		if object == null:
			Global.addwindow("uid://8ogs475b2e7p", "spawner error", {"text": "object is null", "bug": true}, null)
			return
	if timeBetweenSpawns == null:
		Global.addwindow("uid://8ogs475b2e7p", "spawner error", {"text": "timer is not set", "bug": true}, null)
		return
	if objectlimit >= 0:
		if $spawnedobjects.get_child_count() >= objectlimit:
		
			return
	var inst = null
	if copyExistingObject == false:
		inst = object.instantiate()
	else:
		inst = copiedobj.duplicate()
		if "EnemyStats" in inst:
			inst.EnemyStats = inst.EnemyStats.duplicate()
	if inst == null:
		return
	inst.position.x = randf_range(global_position.x,global_position.x + size.x)
	inst.position.y = randf_range(global_position.y,global_position.y + size.y)
	$spawnedobjects.add_child(inst)
	$Timer.wait_time = randf_range(timeBetweenSpawns.x, timeBetweenSpawns.y)
