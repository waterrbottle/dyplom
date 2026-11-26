extends Node2D
var miku = load("uid://c1mdj0cgw5rw3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst = miku.instantiate()
	#inst.freeze = true
	inst.position = get_parent().get_parent().global_position
	
	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(inst)
	get_parent().get_parent().get_parent().queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
