extends Control
@export var scene = ""
var moving = false
var clickpos := Vector2(0,0)
var initialposition := Vector2(0,0)
var active = false
var appscene = null
var acceptinput = false
var appvalid = false
var  front = false # activates window on start
@export var nameoverwrite = ""
@onready var scenepath = $Panel/SubViewport
@export var builtin = false
# Called when the node enters the scene tree for the first time.
func updatesize(wsize: Vector2):
		$Panel/SubViewport.size = wsize
		
		$Panel.size = Vector2( wsize.x + 10, wsize.y + 32)
		%display.size = wsize
		%display.position = %display.size/2 *-1 + Vector2(0,11)
func spawnapp():
	
	if ResourceLoader.exists(scene, "PackedScene"):
		
		var inst = load(scene).instantiate()
		
		if inst.get_node_or_null("Leveldata") == null:
			print("ERROR")
			Global.addwindow("res://scenes/apps/sysmessenger/sysmessenger.tscn", "actual game bug", ["app " + str(scene) + " doesnt have window config node.",true],null)
			queue_free()
			return
		var windowdata = inst.get_node("Leveldata")
		$Panel/SubViewport.size = windowdata.scenesize
		%windownamelabel.text = windowdata.windowname
		if nameoverwrite != "":
			%windownamelabel.text = nameoverwrite
		$Panel.size = Vector2( windowdata.scenesize.x + 10, windowdata.scenesize.y + 32)
		
		$Panel/SubViewport.add_child(inst)
		appscene = get_node("Panel/SubViewport").get_child(0)
		%display.size = Vector2( windowdata.scenesize.x, windowdata.scenesize.y)
		%display.position = %display.size/2 *-1 + Vector2(0,11)
		
		appvalid=true
	else:
		Global.addwindow("res://scenes/apps/sysmessenger/sysmessenger.tscn", "actual game bug", ["cant open the scene. file " +str(scene) +" does not exist.",true],null)
		queue_free()
	
func _ready() -> void:
	if front == true:
		active = true
		Global.ondesktop = false
		move_to_front()
		#get_parent().get_parent().updateactivewindow()
	$Panel.position = Vector2(randi_range(1,100),randi_range(1,100))
	if $Panel/SubViewport.get_child_count() == 0:
		spawnapp()
	
	if appvalid == true:
		Global.activetype = scenepath.get_child(0).get_node("Leveldata").type
		if get_parent().get_parent() != null:
			if "updateactivewindow" in get_parent().get_parent():
				get_parent().get_parent().updateactivewindow()
	pass # Replace with function body.

func _input(event: InputEvent) -> void:

	if not acceptinput:
		return

	if event is InputEventMouse:
		var shifted_event = event.duplicate()
		shifted_event.position = Vector2(%display.get_local_mouse_position()) - Vector2(0, 3)
			

		if event is InputEventMouseButton and event.pressed:

			if Global.qtopen == true:
				return
		$Panel/SubViewport.push_input(shifted_event)
	elif event is InputEventKey:
		$Panel/SubViewport.push_input(event)



func despawn_character_from_all():
	if scenepath.get_child(0).get_node("Leveldata").type == "level":
		if active == true:
			scenepath.get_child(0).get_node("Player").despawn()
func character_teleportation_handler():
	if active == false:
		if appvalid == true:
			if scenepath.get_child(0).get_node("Leveldata").type == "level":
				if scenepath.get_child(0).get_node("Player").active == true:
					if Global.activetype == "level":
						scenepath.get_child(0).get_node("Player").despawn()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	$Panel/StaticBody2D/CollisionShape2D.shape.size = $Panel.size
	$Panel/StaticBody2D/CollisionShape2D.position = $Panel.size/2
	if scenepath.get_child_count() == 0:
		Global.addwindow("res://scenes/apps/sysmessenger/sysmessenger.tscn", "actual game bug", ["window exists but app doesnt.",true],null)
		queue_free()
		return
	if moving == true:
		$Panel.position = initialposition + get_viewport().get_mouse_position() - clickpos
	
	if builtin == true:
		$Panel/TextureRect/builtin.show()

	if active == false:

		#$Panel/buttons/focusbutton.mouse_filter = 0
		acceptinput = false

		$Panel/TextureRect/unactive.show()
		

			
	else:
		
		#$Panel/buttons/focusbutton.mouse_filter = 2
		if $Timer.is_stopped():
			$Timer.start()
			
			
			
		$Panel/TextureRect/unactive.hide()
		if scenepath.get_child(0).get_node("Leveldata").type == "level":
			if $Panel/SubViewport.get_child(0).get_node("Player").active == false:
				
				$Panel/SubViewport.get_child(0).get_node("Player").spawn()
	


func _on_topbar_button_down() -> void:
	#get_parent().add_child(self.duplicate())

	#if get_parent() != null:
	#	for n in get_parent().get_children():
	#		n.z_index = 0
	updatepos()
	activate_window()
	
	
func updatepos():
	#move_to_front()
	#get_parent().get_parent().updateactivewindow()
	moving = true
	clickpos = get_viewport().get_mouse_position()
	initialposition = $Panel.position
	

func _on_topbar_button_up() -> void:
	moving = false


func _on_exitbutton_pressed() -> void:
	queue_free()


func _on_focusbutton_pressed() -> void:
	pass
	


func _on_focusbutton_button_down() -> void:
	activate_window()

func activate_window():
	Global.activetype = scenepath.get_child(0).get_node("Leveldata").type
	active = true
	Global.ondesktop = false
	move_to_front()
	if get_parent().get_parent() != null:
		if "updateactivewindow" in get_parent().get_parent():
			get_parent().get_parent().updateactivewindow()
func _on_timer_timeout() -> void:
	acceptinput=true
	
