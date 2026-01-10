extends PanelContainer
var btn = load("res://objects/taskwindow/taskwindowbutton.tscn")

# Called when the node enters the scene tree for the first time.

func updatetasks(tasks: Array):
	
	for n in $VBoxContainer.get_children():
		n.button_down.disconnect(btn_pressed)
		n.free()
	
	for n in tasks:
		var inst = btn.instantiate()

		inst.text = n[0]
		print(n[0])
		$VBoxContainer.add_child(inst)
	
	
	for n in $VBoxContainer.get_children():
		
		n.button_down.connect(btn_pressed.bind(tasks[n.get_index()][1]))
		
		#print("signal.connected")
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("right_click"):
		if Global.quicktasklock == true:
			return
		print("pressed")
		var space = get_world_2d().direct_space_state
		var mousePos = get_viewport().get_mouse_position()
		var params = PhysicsPointQueryParameters2D.new()
		
		params.position = mousePos
		params.collide_with_areas=true
		var spc = space.intersect_point(params, 5)
		if spc:
			
			#SORTER BOTTOM TO TOP
			spc.sort_custom(
				
				func(a, b):
				var obj_a = a.collider
				var obj_b = b.collider
		
		# First, compare Z-Index
				if obj_a.z_index != obj_b.z_index:
					return obj_a.z_index < obj_b.z_index
		
		# If Z-Index is the same, use Tree Order (internal sorting)
				return !obj_a.is_greater_than(obj_b)
				)
			
			var col = spc[spc.size()-1].collider
			
			var hit=false
			if col.is_in_group("player"):

				updatetasks([["suicide",murder.bind("siema", "dwa")]])
				hit=true
			
			if col.is_in_group("file"):
				fileicontasks(col)
				
				hit=true
			
			
			if col.is_in_group("desktop"):
				var filename = "folder"
				for i in range(1000):

					if !DirAccess.dir_exists_absolute("user://MyComputer/Desktop/folder" + str(i)+ "/"):
						filename = "folder" + str(i)
	
						break
					
				updatetasks([["add new folder", Global.addfolder.bind("user://MyComputer/Desktop/", filename)]])
				hit=true
			if col.is_in_group("window"):
				updatetasks([["close window",Global.closewindow.bind("node", col.get_parent().get_parent() )],
				["close all windows", Global.closewindow.bind("all", "")]])
				hit=true
				
				#SEPERATE SCRIPT FOR INSIDE OF THE WINDOW
				space = col.get_parent().get_node("SubViewport").get_child(0).get_world_2d().direct_space_state
				params.position = col.get_parent().get_node("SubViewport").get_child(0).get_global_mouse_position()
				params.collide_with_areas=true
				
				var spc2 = space.intersect_point(params, 32)
				print(spc2)
				if spc2:
					
					spc2.sort_custom(
						func(a, b):
						var obj_a = a.collider
						var obj_b = b.collider

						if obj_a.z_index != obj_b.z_index:
							return obj_a.z_index < obj_b.z_index
						
						return !obj_a.is_greater_than(obj_b)
						)
					print("TUR")
					var col2 = spc2[spc2.size()-1].collider
					if col2.is_in_group("player"):
						updatetasks(["suicide", "open health bar"])
					if col2.is_in_group("file"):
						
						fileicontasks(col2)
			if hit == false:
				updatetasks([])
			
func fileicontasks(col):
	updatetasks([["rename",rename.bind(col) ],["delete", Global.deletefolder.bind(col.get_parent().path + col.get_parent().filename)]])


func btn_pressed(n):
	n.call()
func rename(col):
	col.get_parent().edit=true
	col.get_parent().get_node("TextEdit").grab_focus()

func murder(cstm_mg,cstm2):
	print(cstm_mg)
	print(cstm2)
