extends Control
var type = "folder"
var subtype = "text"
var scenepath = ""
var adata = ["", false]
var edit = false
var path = ""
var filename = ""
var mouseInArea = false
var onetime = true
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.
	#$TextEdit.get_child(5,true).queue_free()
func image(img):
	$AnimatedSprite2D.hide()
	$TextureRect.texture = load(img)
	
func rename():
	edit=true
func hi():
	Global.updatetasks([["what the flip", Global.addfolder.bind("user://MyComputer/Desktop/", filename)]])
	print("done")
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if onetime == true:
			if event.button_index == 2:
				
				if mouseInArea == true:
					
					if event.pressed == true:
						
						
						Global.quicktasklock = true
						Global.updatetasks([["rename",rename.bind($Area2D/CollisionShape2D) ],["delete", Global.deletefolder.bind(path + filename)]])
						
			onetime = false
	else:
		pass
		onetime=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	filename = $Label.text
	if edit == true:
		$TextEdit.show()
		$Label.hide()
		
	else:
		$TextEdit.hide()
		$Label.show()



func _on_text_edit_text_submitted(new_text: String) -> void:
	#if type == "folder":
	DirAccess.rename_absolute(path+$Label.text, path+$TextEdit.text)

	$Label.text = $TextEdit.text
	


func _on_text_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on==false:
		edit=false




func _on_mouse_entered() -> void:
	mouseInArea=true



func _on_mouse_exited() -> void:
	mouseInArea=false
