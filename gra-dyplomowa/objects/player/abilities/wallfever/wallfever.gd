extends Node2D

@export var entity : CharacterBody2D
@export var active = true
var velsavex = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entity == null:
		return
	if active == false:
		return
	
	if entity.is_on_wall():
			
			if !entity.is_on_floor():
				
				if Input.is_key_pressed(KEY_SPACE):
					if 0 == 0:
						entity.wallfever = true
						$GPUParticles2D.emitting = true
	
						if abs(velsavex) > 10:
						
							entity.velocity.y=0
							if abs(entity.velocityhist) > 1000:
								entity.velocityhist /= 1.5

							entity.velocity.y += abs(entity.velocityhist)*-1.0

							entity.velocity.x = entity.velocityhist *-1.5 - 10
	else:
		velsavex = entity.velocity.x
	if abs(entity.velocity.x) < 10:
		velsavex = 0
	if !Input.is_key_pressed(KEY_SPACE) or abs(entity.velocity.x) < 20 or entity.is_on_floor():
		$GPUParticles2D.emitting = false
		if entity.wallfever ==true:
			entity.wallfever = false
			if Input.is_action_pressed("left") and entity.velocity.x > 0:
				entity.velocity.x/=5
			if Input.is_action_pressed("right") and entity.velocity.x < 0:
				entity.velocity.x/=5
			if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
				entity.velocity.x/=1.1
