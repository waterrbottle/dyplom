extends Node

@export var entity: Node
@export var damagearea: Area2D
@export_category("DAMAGE (random x, y)")
@export var setdamage = Vector2i(1,1)
@export var getdamage = Vector2i(5,5)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.active==true:
			body.damage(randi_range(setdamage.x,setdamage.y))
	if body.is_in_group("fist"):
		if body.active == true:
			entity.EnemyStats.health -= randi_range(getdamage.x,getdamage.y)
			entity.velocity.y = -500 + body.bodyvel.y * 2
			if abs(body.dir) == 1:
				entity.velocity.x = 100 * body.dir + body.bodyvel.x * 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damagearea.connect("body_entered", _on_area_2d_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
