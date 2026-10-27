@tool
extends ColorRect
@export_category("JUMP PAD")
@export var strength = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Jumppad/CollisionShape2D.shape.size = size
	$Jumppad/CollisionShape2D.position = size/2

	#rotation += PI * delta
	for body in $Jumppad.get_overlapping_bodies():
		if body is CharacterBody2D:
			if strength.x > 0:
				if body.velocity.x < strength.x:
					body.velocity.x += strength.x
			if strength.x < 0:
				if body.velocity.x > strength.x:
					body.velocity.x += strength.x
			if strength.y > 0:
				if body.velocity.y < strength.y:
					body.velocity.y += strength.y
			if strength.y < 0:
				if body.velocity.y > strength.y:
					body.velocity.y += strength.y
			body.move_and_slide()
