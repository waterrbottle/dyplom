extends Node

@export var entity: Node
@export var area: Area2D
@export_category("MOVEMENT")
@export_range(0, 1000) var speed = 50.0
var mod = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.connect("body_entered", on_body_entered)

func on_body_entered(body):
	if mod.y < 0:
		mod.y = abs(mod.y)*1
	else:
		mod.y = abs(mod.y)*-1
	if mod.x < 0:
		mod.x = abs(mod.x)*-1
	else:
		mod.x = abs(mod.x)*1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	entity.velocity.x = mod.x * speed
	entity.velocity.y = mod.y * speed
	entity.move_and_slide()
	
