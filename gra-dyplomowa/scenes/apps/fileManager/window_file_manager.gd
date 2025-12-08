extends Node2D

var icon = load("res://objects/TheWindowSystem/windowFileManager/FileIcon/fileicon.tscn")
var gdirs = null
var dirstring = "res://MyComputer/"
var dirlist =["MyComputer"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	
func updatedirstring():
	dirstring = "res://"
	for i in dirlist:
		dirstring += i +"/"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if 	get_parent().get_parent().get_parent().active == true:
		for n in $CanvasLayer/VBoxContainer.get_children():
			if n.get_child(2).is_pressed():
				if get_parent().get_parent().get_parent().acceptinput == true:
					if n.type == "folder":
						dirlist.append(n.get_child(1).text)
				
						for m in $CanvasLayer/VBoxContainer.get_children():
							m.queue_free()
						updatedirstring()
						update()
					if n.type == "document":
						if Input.is_action_just_pressed("click"):
							Input.action_release("click")
							get_parent().get_parent().get_parent().active = false
							var file = FileAccess.open(dirstring + n.get_child(1).text, FileAccess.READ)
							if n.subtype == "text":
								var content = file.get_as_text()
								Global.addwindow("res://scenes/apps/notepad/notepad.tscn", n.get_child(1).text, [content, true])
							if n.subtype == "image":
								Global.addwindow("res://scenes/apps/ImageViewer/imageviewer.tscn", n.get_child(1).text, [dirstring + n.get_child(1).text])
						
	%dirlabel.text = dirstring


func update():
	var dir := DirAccess.open(dirstring)
	if dir == null: printerr("Could not open folder"); return
	
	dir.list_dir_begin()
	gdirs = dir.get_directories()
	for file: String in dir.get_files():
		#var resource := load(dir.get_current_dir() + "/" + file)
		print(file)
		var inst = icon.instantiate()
		inst.get_child(0).play("document")
		inst.type = "document"
		inst.get_child(1).text = str(file)
		if (file.get_extension()) == "png" or file.get_extension() == "jpg" or file.get_extension() == "svg" or file.get_extension() == "webp":
			inst.subtype = "image"
		
		$CanvasLayer/VBoxContainer.add_child(inst)
		

	for dirs: String in dir.get_directories():
		#var resource := load(dir.get_current_dir() + "/" + file)
		var inst = icon.instantiate()
		inst.get_child(0).play("folder")
		inst.type = "folder"
		inst.get_child(1).text = str(dirs)
		$CanvasLayer/VBoxContainer.add_child(inst)
		print(dirs)


func _on_back_button_pressed() -> void:
	for m in $CanvasLayer/VBoxContainer.get_children():
		m.queue_free()
	dirlist.remove_at(dirlist.size()-1)
	updatedirstring()
	update()
