extends Node
var areasitems = []
@export var entity: Node
@export var damagearea: Area2D
@export_category("DAMAGE (random x, y)")
@export var setdamage = Vector2i(1,1)
@export var getdamage = Vector2i(5,5)
@export var damagers = [["fist", {"damagemin": 1, "damagemax": 1, "kb_strength": 500}], ["item", {"id": "bomb", "damagemin": 1, "damagemax": 5, "kb_strength": 500}]]
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.active==true:
			body.damage(randi_range(setdamage.x,setdamage.y))

func damagersetter(n,area,dmgtype):
	print("EntityExtention: Damagerbasic: damage on " + str(entity) + " with: " +  str(dmgtype))
	entity.EnemyStats.health -= randi_range(n[1]["damagemin"],n[1]["damagemax"])
	if dmgtype == "fist":
		entity.velocity.y = -n[1]["kb_strength"] + area.bodyvel.y * 2
		if abs(area.dir) == 1:
			entity.velocity.x = 100 * area.dir + area.bodyvel.x * 3

func _on_area_2d_area_exited(area: Node2D) -> void:
	if areasitems.has(area):
		areasitems.erase(area)
	
func _on_area_2d_area_entered(area: Node2D) -> void:
	
	for n in damagers:
		if n[0] == "fist":
			if area.is_in_group("fist"):
				damagersetter(n,area,"fist")
		if n[0] == "item":
			
			var itemnode = area.get_parent().get_parent()
			
			if itemnode != null:
				if itemnode.is_in_group("item"):
					areasitems.append(area)
					areasitems.append(n)

				else:
					pass
					#print("EntityExtention: Damagerbasic: it looks like the area is not an item: " + str(area))
			else:
				pass
				#print("EntityExtention: Damagerbasic: it looks like the area is not an item: " + str(area))
					
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damagearea.connect("body_entered", _on_area_2d_body_entered)
	damagearea.connect("area_entered", _on_area_2d_area_entered)
	damagearea.connect("area_exited", _on_area_2d_area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	for n in areasitems.size():
		if areasitems[n] == null:
			areasitems.remove_at(n)
			areasitems.remove_at(n)
			break
		if areasitems[n] is Area2D:
			if areasitems[n].get_parent().get_parent().used == true:
				#areasitems[n].get_parent().get_parent().used = false
				damagersetter(areasitems[n+1],areasitems[n],"item")
				areasitems.remove_at(n)
				areasitems.remove_at(n)
				break
	
