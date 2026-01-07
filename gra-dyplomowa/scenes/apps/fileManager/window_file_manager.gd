extends Node

var icon = load("res://objects/TheWindowSystem/windowFileManager/FileIcon/fileicon.tscn")
var gdirs = null
var dirstring = "user://MyComputer/"
var dirlist =["MyComputer"]
@export var mode = "windowed"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	if mode == "desktop":
		dirstring = "user://MyComputer/Desktop/"
		dirlist = ["MyComputer", "Desktop"]
	
func updatedirstring():
	dirstring = "user://"
	for i in dirlist:
		dirstring += i +"/"


func fileopening(n):
	if mode == "windowed":
		if n.type == "folder":
			dirlist.append(n.get_child(1).text)
			for m in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
				m.queue_free()
			updatedirstring()
			update()
	else:
		if n.type == "folder":
			
			Global.addwindow("res://scenes/apps/fileManager/WindowFileManager.tscn", "", [["MyComputer", "Desktop", n.get_child(1).text]])
			Global.ondesktop=false
	if n.type == "document":
		if Input.is_action_just_pressed("click"):
			if mode == "windowed":
				Input.action_release("click")
				get_parent().get_parent().get_parent().active = false
			var file = FileAccess.open(dirstring + n.get_child(1).text, FileAccess.READ)
			if n.subtype == "text":
				var content = file.get_as_text()
				Global.addwindow("res://scenes/apps/notepad/notepad.tscn", n.get_child(1).text, [content, true])
			if n.subtype == "image":
				Global.addwindow("res://scenes/apps/ImageViewer/imageviewer.tscn", n.get_child(1).text, [dirstring + n.get_child(1).text])
			if n.subtype == "music":
				Global.addwindow("res://scenes/apps/musicplayer/musicplayer.tscn", "audio_player.exe", [dirstring + n.get_child(1).text,n.get_child(1).text ])
	if n.type == "app":
		if Input.is_action_just_pressed("click"):
			Input.action_release("click")
			if mode == "windowed":
				get_parent().get_parent().get_parent().active = false
			print("data")

			Global.addwindow(n.scenepath, n.get_child(1).text, (n.adata))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mode == "windowed":
		if get_parent().get_parent().get_parent().active == true:
			for n in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
				if n.get_child(2).is_pressed():
					if get_parent().get_parent().get_parent().acceptinput == true:
						fileopening(n)
		%dirlabel.text = dirstring
	if mode == "desktop":
		$GridContainer.columns = $GridContainer.size.x/54
		for n in $GridContainer.get_children():
			if n.get_child(2).is_pressed():
				if Input.is_action_just_pressed("click"):
					fileopening(n)
	


func update():

	if mode == "desktop":
		dirstring = "user://MyComputer/Desktop/"
		for n in $GridContainer.get_children():
			n.queue_free()
			

	var dir := DirAccess.open(dirstring)
	if dir == null: printerr("Could not open folder"); return
	
	dir.list_dir_begin()
	gdirs = dir.get_directories()
	for file: String in dir.get_files():
		if (file.get_extension()) == "import" or  (file.get_extension()) == "uid":
			continue
		#var resource := load(dir.get_current_dir() + "/" + file)

		var inst = icon.instantiate()
		inst.get_child(0).play("document")
		inst.type = "document"
		inst.path = dirstring
		inst.get_child(1).text = str(file)
		
		var filer = FileAccess.open(dirstring+file, FileAccess.READ)
		
		var content = filer.get_line()
		
		if content=="app-redirect":
			inst.type = "app"
			
			for n in range(10):
			
				var contenti = filer.get_line()
				
				if n == 1:
					inst.scenepath = str(contenti)
				if n == 5:
					inst.get_child(1).text = str(contenti)
				if n == 3:

					inst.image(contenti)
				if n == 7:
					if contenti != "":
						inst.adata= str_to_var(contenti)
					
						
		if (file.get_extension()) == "png" or file.get_extension() == "jpg" or file.get_extension() == "svg" or file.get_extension() == "webp":
			inst.subtype = "image"
		if (file.get_extension()) == "mp3" or file.get_extension() == "wav":
			inst.subtype = "music"
		if mode == "windowed":
			$CanvasLayer/ScrollContainer/VBoxContainer.add_child(inst)
		else:
			$GridContainer.add_child(inst)
		
		
	
	for dirs: String in dir.get_directories():
		#var resource := load(dir.get_current_dir() + "/" + file)
		var inst = icon.instantiate()
		inst.get_child(0).play("folder")
		inst.type = "folder"
		inst.path = dirstring
		inst.get_child(1).text = str(dirs)
		if mode == "windowed":
			$CanvasLayer/ScrollContainer/VBoxContainer.add_child(inst)
		else:
			$GridContainer.add_child(inst)
		


func _on_back_button_pressed() -> void:
	for m in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
		m.queue_free()
	if dirlist.size() > 0:
		dirlist.remove_at(dirlist.size()-1)
	updatedirstring()
	update()
