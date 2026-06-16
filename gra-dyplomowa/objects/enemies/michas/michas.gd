extends CharacterBody2D
@export var EnemyStats: Resource



func _process(delta: float) -> void:
	
	if EnemyStats.health <= 0:
		queue_free()
