extends Node2D
@export var entity : CharacterBody2D

var walktimer = [0, true]
@export var active = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entity == null:
		return
	if active == false:
		return
	if abs(entity.velocity.x) > 30:
		if entity.is_on_floor():
			if Input.is_action_pressed("down"):
				entity.sneak = true
			else:
				entity.sneak = false
		

			
	else:
		entity.sneak=false
	if entity.sneak == true:
		if not entity.is_on_floor():
			if Input.is_action_pressed("down"):
				entity.sneak=true
			else:
				entity.sneak=false
			if Input.is_action_pressed("jump"):
				entity.sneak = false
