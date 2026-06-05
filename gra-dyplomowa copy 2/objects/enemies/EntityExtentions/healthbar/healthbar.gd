@tool
extends Node2D
@export var entity = "enemy.exe"
@export var healthbarlengt = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		$name.text = str(entity)
		$Control/Panel.size.x = healthbarlengt
		$Control/Panel.position = -Vector2($Control/Panel.size.x,$Control/Panel.size.y)/2
		if get_parent() != null:
			if "EnemyStats" in get_parent():
				$Control/Panel/ProgressBar.max_value = get_parent().EnemyStats.max_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$name.text = str(entity)
		$Control/Panel.position = -Vector2($Control/Panel.size.x,$Control/Panel.size.y)/2
		$Control/Panel.size.x = healthbarlengt
	else:
		if get_parent() != null:
			if "EnemyStats" in get_parent() :

				$Control/Panel/ProgressBar.value = get_parent().EnemyStats.health
