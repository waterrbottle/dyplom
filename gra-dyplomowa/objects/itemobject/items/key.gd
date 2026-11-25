extends Node2D
var display = true
var active = true
var used = false
@export var objectid = "key"

func _on_object_body_entered(body: Node) -> void:

	if $Itemmaster.display == false:

		if body.is_in_group("player"):
			print("key picked up")
			
			if Global.item == "":
				print("key picked up")
				queue_free()
				Global.add_item("key")
