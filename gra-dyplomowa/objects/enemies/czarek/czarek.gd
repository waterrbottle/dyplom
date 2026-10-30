extends CharacterBody2D

@export var EnemyStats: Resource
@export_enum("normal", "lobotomized") var type = ""


func _ready() -> void:
	if type == "lobotomized":
		$Stats.entity = "zlobotomizowany " + $Stats.entity
		$Panel.hide()
		$extentions/movement/MovementDasher.active = false

func _process(delta: float) -> void:
	if EnemyStats.health <= 0:
		queue_free()
		
