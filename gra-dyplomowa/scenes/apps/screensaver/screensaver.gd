extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(100):
		var inst = $CSGSphere3D.duplicate()
		inst.material = StandardMaterial3D.new()
		inst.position.x = randi_range(-30,30)
		inst.position.y = randi_range(-30,30)
		inst.position.z = randi_range(-30,30)
		inst.material.albedo_color = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1), 1.0)
		add_child(inst)
	$CSGSphere3D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
