extends Node2D
var content = {"text": "", "canSave": true, "savePath": ""} #["",false, ""]
var contentdata = {}

func _ready() -> void:
	if contentdata != null:
		content = contentdata
	else:
		Global.bug("notepad: contentdata is null")
	# kod przypisujacy tekst do aplikacji
	if content.has("text"):
		$AppCode/ColorRect/TextEdit.text = content["text"]

		#$AppCode/ColorRect/TextEdit.editable=false
	else:
		Global.bug("Notepad: contentdata is invalid")
		$AppCode/ColorRect/TextEdit.editable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if content.has("canSave"):
		if content["canSave"] == true:
			var path = content["savePath"]
			print(path)
			if FileAccess.file_exists(path):
	
				var file = FileAccess.open(path, FileAccess.WRITE)
				file.store_string($AppCode/ColorRect/TextEdit.text)
