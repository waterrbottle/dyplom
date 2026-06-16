extends CharacterBody2D
@export var EnemyStats: Resource




func _physics_process(delta: float) -> void:
	if velocity.x <0:
		$Node2D.scale.x = abs($Node2D.scale.x) 
	else:
		$Node2D.scale.x = abs($Node2D.scale.x) * -1
	
func _process(delta: float) -> void:


	if EnemyStats.health <= 0:
		queue_free()
