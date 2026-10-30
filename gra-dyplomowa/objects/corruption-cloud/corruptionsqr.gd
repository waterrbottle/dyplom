extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles2D4.show()
	$GPUParticles2D3.show()
	$GPUParticles2D3.visibility_rect = Rect2(-size.x / 2,-size.y / 2,size.x*4,size.y*4)
	$GPUParticles2D3.show()
	$GPUParticles2D4.visibility_rect = Rect2(-size.x / 2,-size.y / 2,size.x*4,size.y*4)
	$GPUParticles2D4.show()
	$Area2D/CollisionShape2D.shape.size = size
	$Area2D/CollisionShape2D.position = size / 2
	$GPUParticles2D3.process_material.emission_shape_scale = Vector3(size.x,size.y,0)
	$GPUParticles2D3.process_material.emission_shape_offset = Vector3(size.x,size.y,0)
	$GPUParticles2D4.process_material.emission_shape_scale = Vector3(size.x,size.y,0)
	$GPUParticles2D4.process_material.emission_shape_offset = Vector3(size.x,size.y,0)
	self_modulate = Color(0.0, 0.0, 0.0, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
