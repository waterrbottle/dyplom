@tool
extends Node2D

@export_enum("teleportation", "idk") var markerType = "default"

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	match markerType:
		"teleportation":
			modulate = Color(0.0, 0.733, 1.0, 1.0)
			$Label.text = "will teleport here"
		"idk":
			modulate = Color(1.0, 0.0, 0.0, 1.0)
			$Label.text = "something weird"
	

func _ready() -> void:
	hide()
