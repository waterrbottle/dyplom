extends Node

var icon = load("res://objects/TheWindowSystem/windowFileManager/FileIcon/fileicon.tscn")
var gdirs = null
var dirstring = "user://MyComputer/"
var dirlist =["MyComputer"]
@export var mode = "windowed"
var inside = false
var currentfles = []
var counter = 0
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

func remove_last_directory(path: String) -> String:
	if path.ends_with("/") or path.ends_with("\\"):
		path = path.left(-1)
	var base_dir = path.get_base_dir()
	if not base_dir.ends_with("/"):
		base_dir += "/"
	return base_dir

func fileopening(n):

	if mode == "windowed":
		if n.type == "folder":
			if n.corrupted == true:
				Global.addwindow("uid://8ogs475b2e7p", "ERROR", {"text": "this folder is corrupted! explore the folder to uncorrupt it."}, null)
				return
			dirstring = dirstring + n.get_child(1).text + "/"
		#	dirlist.append(n.get_child(1).text)
			for m in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
				m.queue_free()
		#	updatedirstring()
			update()
	else:
		if n.type == "folder":
			
			if n.corrupted == true:
				Global.addwindow("uid://8ogs475b2e7p", "ERROR", {"text": "this folder is corrupted! explore the folder to uncorrupt it."}, null)
				return
			Global.addwindow("res://scenes/apps/fileManager/WindowFileManager.tscn", "", {"dirstring": "user://MyComputer/Desktop/" + n.get_child(1).text + "/"}, null)
			
			Global.ondesktop=false
	if n.type == "document":
		if Input.is_action_just_pressed("click"):
			if n.corrupted == true:
				Global.addwindow("uid://8ogs475b2e7p", "ERROR", {"text": "this file is corrupted! explore the folder to uncorrupt it."}, null)
				return
			if mode == "windowed":
				Input.action_release("click")
				get_parent().get_parent().get_parent().active = false
			var file = FileAccess.open(dirstring + n.get_child(1).text, FileAccess.READ)
			if n.subtype == "text":
				var content = file.get_as_text()
				Global.addwindow("res://scenes/apps/notepad/notepad.tscn", n.get_child(1).text, [content, true], null)
			if n.subtype == "image":
				Global.addwindow("res://scenes/apps/ImageViewer/imageviewer.tscn", n.get_child(1).text, [dirstring + n.get_child(1).text],null)
			if n.subtype == "music":
				Global.addwindow("res://scenes/apps/musicplayer/musicplayer.tscn", "audio_player.exe", [dirstring + n.get_child(1).text,n.get_child(1).text ],null)
	if n.type == "app":
		
		if Input.is_action_just_pressed("click"):
			if n.corrupted == true:
				Global.addwindow("uid://8ogs475b2e7p", "ERROR", {"text": "this application is corrupted! explore the folder to uncorrupt it."}, null)
				return
			if n.corrupted == true:
				return
			Input.action_release("click")
			if mode == "windowed":
				get_parent().get_parent().get_parent().active = false


			Global.addwindow(n.scenepath, n.get_child(1).text, n.adata,null)
	if n.type == "levelfolder":
		
		if Input.is_action_just_pressed("click"):
			Input.action_release("click")


			Global.addwindow("uid://8ogs475b2e7p", n.get_child(1).text, {"text": "this folder is corrupted, what do you want to do with it?", "bug": false,"image": load("uid://x4v2ehknnfe"), "btnf": [["view contents", "open", {"scene": "uid://bweuy5c10gc1l", "content": {"dirstring": n.path + n.get_child(1).text + "/"}}],["TRY OPENING THE FILE ", "open", {"scene": "res://scenes/levels/level1.tscn", "content": ""}]] },null)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	if counter > 5:
		checkfornew()
		counter = 0
	
	
	if mode == "windowed":
		if get_parent().get_parent().get_parent().active == true:
			for n in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():

				if n.get_child(2).is_pressed():

					n.disable = true
					
					if get_parent().get_parent().get_parent().acceptinput == true:
						
						fileopening(n)
		%dirlabel.text = dirstring
	if mode == "desktop":
		$GridContainer.columns = $GridContainer.size.x/54
		for n in $GridContainer.get_children():
			if n.get_child(2).is_pressed():
				if Input.is_action_just_pressed("click"):
					fileopening(n)
	

func checkfornew():
	var newfiles = []
	var dir := DirAccess.open(dirstring)
	if dir == null: printerr("Could not open folder"); return
	
	dir.list_dir_begin()
	gdirs = dir.get_directories()
	
	for file: String in dir.get_files():
		newfiles.append(file)
	if newfiles != currentfles:
		update()

func update():
	var corrupted = []
	print("time for file update!")
	if mode == "desktop":
		dirstring = "user://MyComputer/Desktop/"
		for n in $GridContainer.get_children():
			n.queue_free()
	if mode == "windowed":
		for n in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
			n.queue_free()
			

	var dir := DirAccess.open(dirstring)
	if dir == null: printerr("Could not open folder"); return
	
	for file: String in dir.get_files():
		if file == "filedata.json":

			var fp = FileAccess.open(dirstring + file, FileAccess.READ)

			if readfolderdata(fp) != null:

				corrupted = readfolderdata(fp)["corruptedfiles"]
	
	
	dir.list_dir_begin()
	gdirs = dir.get_directories()
	currentfles.clear()
	for file: String in dir.get_files():
		currentfles.append(file)
		if (file.get_extension()) == "import" or  (file.get_extension()) == "uid" or(file.get_extension()) == "json" :
			continue
		#var resource := load(dir.get_current_dir() + "/" + file)

		var inst = icon.instantiate()
		inst.get_child(0).play("document")
		
		inst.type = "document"
		inst.path = dirstring
		inst.ext = file.get_extension()
		inst.get_child(1).text = str(file)
		
		var filer = FileAccess.open(dirstring+file, FileAccess.READ)
		
		var content = filer.get_line()
		
		for n in corrupted:
			
			if n == file:
				inst.corrupted = true
				print("setting to corrupt " + n)

		
				
		if content=="app-redirect":
			inst.type = "app"
			
			for n in range(10):
			
				var contenti = filer.get_line()
				
				if n == 1:
					inst.scenepath = str(contenti)
				if n == 5:
					inst.nameoverride = str(contenti)
				if n == 3:

					inst.image(contenti)
				if n == 7:
					if contenti != "":

						inst.adata= str_to_var(contenti)
					
		inst.get_child(0).play("unknown")
		if (file.get_extension()) == "txt" or file.get_extension() == "docx" or file.get_extension() == "svg" or file.get_extension() == "rtf":
			inst.subtype = "text"
			inst.get_child(0).play("document")
		if (file.get_extension()) == "png" or file.get_extension() == "jpg" or file.get_extension() == "svg" or file.get_extension() == "webp":
			inst.subtype = "image"
			inst.get_child(0).play("image")
		if (file.get_extension()) == "mp3" or file.get_extension() == "wav":
			inst.get_child(0).play("audio")
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
		
		for n in corrupted:
			
			if n == dirs:
				inst.corrupted = true
				print("setting to corrupt " + n)
		var filesindir := DirAccess.open(dirstring + dirs + "/")

		for filesinfolder in filesindir.get_files():

			if filesinfolder == "folderproperties.json":
				var fp = FileAccess.open(dirstring + dirs + "/" + filesinfolder, FileAccess.READ)
				if readfolderdata(fp) != null:
					var dict = readfolderdata(fp)
					if dict.has("corrupted"):
						if dict["corrupted"] == true:

							if dict["level"] == true:
								inst.type = "levelfolder"
								
							inst.corrupted = true
		if mode == "windowed":
			$CanvasLayer/ScrollContainer/VBoxContainer.add_child(inst)
		else:
			$GridContainer.add_child(inst)
		

func readfolderdata(fp):

	var json_string = ( (fp.get_as_text()) )
	
	
	var json = JSON.new()
	var error = json.parse(json_string)

	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:

			return data_received
			
		else:
			return null
			print("Unexpected data")
	else:
		return null
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())


func _on_back_button_pressed() -> void:
	for m in $CanvasLayer/ScrollContainer/VBoxContainer.get_children():
		m.queue_free()
	#if dirlist.size() > 0:
	#	dirlist.remove_at(dirlist.size()-1)
	#updatedirstring()
	dirstring=remove_last_directory(dirstring)
	update()
