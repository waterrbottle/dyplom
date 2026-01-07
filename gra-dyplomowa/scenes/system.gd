extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:


	%TimeLabel.text = Time.get_time_string_from_system()  #Time.get_time_dict_from_system()["hour"] , ":" , Time.get_time_dict_from_system()["minute"])
	if Global.ondesktop == false:
		if $Player.active==true:
			$desktopfocus.mouse_filter=1
			$Player.despawn()
	
	#quicktools script
	if Input.is_action_just_pressed("right_click"):

							
		$taskwindow.position = get_viewport().get_mouse_position()
		$taskwindow.show()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$taskwindow.hide()

func updateactivewindow():

	for n in $Windows.get_child_count():
		$Windows.get_child(n).active = false
		if n == $Windows.get_child_count()-1:
			$Windows.get_child(n).active = true
		


func _on_startbutton_pressed() -> void:
	if $startmenu.visible == true:
		$startmenu.hide()
		return
	else:

		$startmenu.show()



func _on_desktopfocus_pressed() -> void:
	for n in $Windows.get_children():
		if Global.ondesktop == false:
			$Player.spawn()
		n.active = false
		Global.ondesktop = true
	$desktopfocus.mouse_filter=2
		
