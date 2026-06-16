extends Control
var type = "folder" # typ pliku - moze byc folder albo file.
var subtype = "text" # media type - moze byc text image sound video
var edit = false # jezeli true uzytkownik zmienia nazwe pliku
var path = "" # sciezka danego pliku
var filename = "" # nazwa pliku
var mouseInArea = false # myszka dotyka ikonki pliku
var onetime = true 
var exit = false # zmiennia setujac
var nameoverride = ""
var ext = ""
var adata = ["",false]
var scenepath = "" # used just for storing the real path 
var disable = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.
	#$TextEdit.get_child(5,true).queue_free()
	if type != "levelfolder":
		$AnimatedSprite2D.material.set_shader_parameter("glitch_chance", 0)
	else:
		$AnimatedSprite2D.material.set_shader_parameter("glitch_chance", 1)
func image(img):
	$AnimatedSprite2D.hide()
	$TextureRect.texture = load(img)
	
func rename():
	edit=true
	$cooldown.start()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if onetime == true:
			if event.button_index == 2:
				
				if mouseInArea == true:
					
					if event.pressed == true:
						
						
						Global.quicktasklock = true
						Global.updatetasks(["file",$Area2D])
						
						
			onetime = false
	else:
		pass
		onetime=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if disable == true:
		$Button.disabled=true
		$Button.disabled=false
		
	filename = $Label.text
	
	if edit == true:
		$TextEdit.show()
		$Label.hide()
		
	else:
		exit=false
		$TextEdit.hide()
		$Label.show()
	if exit == true:
		print(mouseInArea)
		if Input.is_action_just_pressed("click"):
			if mouseInArea == false:
				edit=false
				print("hi")
	



func _on_text_edit_text_submitted(new_text: String) -> void:
	#if type == "folder":

	if !new_text.validate_filename():
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "invalid name.","bug": false},null)
		$TextEdit.text = ""
	elif DirAccess.dir_exists_absolute(path + new_text):
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "name exists.","bug": false},null)
	else:
		var e = DirAccess.rename_absolute(path+$Label.text, path+$TextEdit.text + "." + ext)
		if e != OK:
			Global.addwindow("uid://8ogs475b2e7p","",{"text": "holy shit rename error: " + error_string(e), "bug": true},null)
		else:
			$Label.text = $TextEdit.text + "." + ext
	


func _on_text_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on==false:
		$TextEdit.text = ""
		edit=false




func _on_mouse_entered() -> void:
	mouseInArea=true




func _on_mouse_exited() -> void:
	mouseInArea=false


func _on_cooldown_timeout() -> void:
	exit = true
	print("dodo")


func _on_button_pressed() -> void:
	print("pres")
