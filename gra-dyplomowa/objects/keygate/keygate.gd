extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "objectid" in body:
		if body.objectid == "key":
			body.queue_free()
			queue_free()
	if "objectid" in body.get_parent():
		if body.get_parent().objectid == "key":
			if body.visible == true:
				body.get_parent().queue_free()
				queue_free()
