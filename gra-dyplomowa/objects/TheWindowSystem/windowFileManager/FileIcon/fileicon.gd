extends Control
var type = "folder"
var subtype = "text"
var scenepath = ""
var adata = ["", false]
var edit = false
var path = ""
var filename = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#$TextEdit.get_child(5,true).queue_free()
func image(img):
	$AnimatedSprite2D.hide()
	$TextureRect.texture = load(img)
	

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


func _on_button_2_pressed() -> void:
	pass # Replace with function body.
