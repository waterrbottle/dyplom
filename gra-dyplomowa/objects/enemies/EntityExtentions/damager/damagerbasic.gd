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
func _on_area_2d_area_entered(area: Node2D) -> void:
	print(area.name)
	if area.is_in_group("fist"):
			print("hit")
			entity.EnemyStats.health -= randi_range(getdamage.x,getdamage.y)
			entity.velocity.y = -500 + area.bodyvel.y * 2
			if abs(area.dir) == 1:
				entity.velocity.x = 100 * area.dir + area.bodyvel.x * 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damagearea.connect("body_entered", _on_area_2d_body_entered)
	damagearea.connect("area_entered", _on_area_2d_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
