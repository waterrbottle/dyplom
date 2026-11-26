extends Node2D

var contentdata = {}
var password = ""
var tscn = ""
var tscndata = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if contentdata == null:
		Global.bug("lockPopup: no data for lockPopup")
		return
	print(contentdata)
	if contentdata.has("password"):
		password = contentdata["password"]
	if contentdata.has("path"):
		tscn = contentdata["path"]
	if contentdata.has("scenedata"):
		tscndata = contentdata["scenedata"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == password:
		
		Global.addwindow({"scene": tscn, "name": name,"data": tscndata,"loc": null})
