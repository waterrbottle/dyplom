extends Area2D

@export var lifetime := 30
@export_category("direction and speed which the object is going")
@export var constant_vel := Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if lifetime >= 0:
		$Timer.wait_time = lifetime
		$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += constant_vel

func _on_timer_timeout() -> void:
	queue_free()
