extends Node
var areasitems = []
@export var entity: Node
@export var damagearea: Area2D
@export_category("DAMAGE setter")
@export var kb = Vector2(-500,-500)
@export var setdamage = Vector2i(1,1)
#@export var getdamage = Vector2i(5,5)
@export var dmgsettercooldon = 0.1
@export_category("DAMAGE getter")
@export var damagers = [["fist", {"damagemin": 1, "damagemax": 1, "kb_strength": Vector2(500,500)}], ["item", {"id": "bomb", "damagemin": 1, "damagemax": 5, "kb_strength": Vector2(500,500)}]]

func _on_area_2d_body_entered(area: Node2D) -> void:
	$Timer.start()
	checkforurt()

func damagergetter(n,area,dmgtype):
	if entity.has_method("got_dmg"):
		entity.got_dmg(dmgtype)
	print("EntityExtention: Damagerbasic: damage on " + str(entity) + " with: " +  str(dmgtype))
	entity.EnemyStats.health -= randi_range(n[1]["damagemin"],n[1]["damagemax"])
	if dmgtype == "fist":
		entity.velocity.y = -n[1]["kb_strength"].x + area.bodyvel.y * 2
		if abs(area.dir) == 1:
			entity.velocity.x = n[1]["kb_strength"].y * area.dir + area.bodyvel.x * 3

func _on_area_2d_area_exited(area: Node2D) -> void:
	if areasitems.has(area):
		areasitems.erase(area)
	
func _on_area_2d_area_entered(area: Node2D) -> void:
	
	for n in damagers:
		if n[0] == "fist":
			if area.is_in_group("fist"):
				
				damagergetter(n,area,"fist")
				
	#	if n[0] == "item":
			
	#		var itemnode = area.get_parent().get_parent()
			
	#		if itemnode != null:
	#			if itemnode.is_in_group("item"):
	#				areasitems.append(area)
	#				areasitems.append(n)

	#			else:
	#				pass
					#print("EntityExtention: Damagerbasic: it looks like the area is not an item: " + str(area))
			else:
				pass
				#print("EntityExtention: Damagerbasic: it looks like the area is not an item: " + str(area))
					
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = dmgsettercooldon
	
	damagearea.connect("body_entered", _on_area_2d_body_entered)
	damagearea.connect("area_entered", _on_area_2d_area_entered)
	damagearea.connect("area_exited", _on_area_2d_area_exited)


func checkforurt():
	for n in damagearea.get_overlapping_bodies():
			if n.is_in_group("player"):
				if n.active==true:
				
					n.damage(randi_range(setdamage.x,setdamage.y), kb)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Timer.time_left <= 0:
		checkforurt()
		$Timer.start()
