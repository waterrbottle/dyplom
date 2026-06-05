extends Resource
class_name BasicEnemy
@export var max_health = 100 
var health = 0: set = _on_health_set
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	setup.call_deferred()

func setup():
	health = max_health
func _on_health_set(value):
	health = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
