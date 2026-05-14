extends Control
var onetimestartmenu=false
var screensaver=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_node("Player"):
		$Player.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:


	%TimeLabel.text = Time.get_time_string_from_system()  #Time.get_time_dict_from_system()["hour"] , ":" , Time.get_time_dict_from_system()["minute"])
	if Global.ondesktop == false:
		if has_node("Player"):
			if $Player.active==true:
				$desktopfocus.mouse_filter=1
				if Global.activetype == "level":
				
					$Player.despawn()
	
	#quicktools script
	if Input.is_action_just_pressed("right_click"):

							
		$taskwindow.position = get_viewport().get_mouse_position()
		$taskwindow.show()
		Global.qtopen = true

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$taskwindow.hide()
		Global.qtopen = false
	
	if $startmenu.visible == true:
		var hasp = false
		for n in ( $startmenu/Area2D.get_overlapping_bodies()):
			if n.is_in_group("player"):
				if onetimestartmenu==true:
					hasp=true
					n.velocity.y = -1000
					n.move_and_slide()
					$startmenu/StaticBody2D.set_collision_layer_value(3,false)
		if hasp == false:
			onetimestartmenu=false
			$startmenu/StaticBody2D.set_collision_layer_value(3,true)
	

func updateactivewindow():

	for n in $Windows.get_child_count():
		$Windows.get_child(n).active = false
		if n == $Windows.get_child_count()-1:
			$Windows.get_child(n).active = true
	print(Global.activetype)
	for n in $Windows.get_children():
		n.character_teleportation_handler()
	


func _on_startbutton_pressed() -> void:
	if $startmenu.visible == true:
		$startmenu/StaticBody2D.set_collision_layer_value(3,false)

		$startmenu.hide()
		return
	else:

		onetimestartmenu=true
		$startmenu.show()



func _on_desktopfocus_pressed() -> void:
	Global.activetype = "desktop"
	for n in $Windows.get_children():
		n.despawn_character_from_all()
	for n in $Windows.get_children():
		if Global.ondesktop == false:
			$Player.spawn()
		n.active = false
	Global.ondesktop = true
	$desktopfocus.mouse_filter=2
		


func _on_sleep_pressed() -> void:
	$screensaver.show()
	$shader.show()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	screensaver=true

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		if screensaver==true:
			$screensaver.hide()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			screensaver=false


func _on_shut_pressed() -> void:
	for n in $Windows.get_children():
		await get_tree().create_timer(randf_range(0.05,0.8)).timeout
		if n != null:
			n.queue_free()
	get_tree().change_scene_to_file("res://scenes/apps/login/login.tscn")
