extends Node2D
@export var itemid = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load_item():
	for n in $item.get_children():
		n.queue_free()
	var loadscn = load("res://objects/itemobject/items/" + str(itemid) +".tscn")
	if loadscn == null:
		return
	var i = loadscn.instantiate()
	i.display = true
	$item.add_child(i)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
