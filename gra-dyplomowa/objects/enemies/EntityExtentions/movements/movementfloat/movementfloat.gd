extends Node

@export var entity: Node
@export_category("areas up down left right")
@export var areas: Array[Area2D] = []
@export_category("MOVEMENT")
@export_range(0, 1000) var speed = 50.0

var mod = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	areas[0].connect("body_entered", on_body_entered_up)
	areas[1].connect("body_entered", on_body_entered_down)
	areas[2].connect("body_entered", on_body_entered_left)
	areas[3].connect("body_entered", on_body_entered_right)

func on_body_entered_up(body):
	mod.y = 1

func on_body_entered_down(body):
	mod.y = -1
	print("DOWN")

func on_body_entered_left(body):
	mod.x = 1

func on_body_entered_right(body):
	mod.x = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	entity.velocity.x = mod.x * speed
	entity.velocity.y = mod.y * speed
	entity.move_and_slide()
	
