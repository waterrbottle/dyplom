extends Node

var windowname = "fileManager.exe"
var icon = load("res://objects/TheWindowSystem/windowFileManager/FileIcon/fileicon.tscn")
var gdirs = null
var dirstring = "res://MyComputer/Desktop/"
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

	for n in $GridContainer.get_children():
		if n.get_child(2).is_pressed():

			if n.type == "folder":
				if Input.is_action_just_pressed("click"):
					Input.action_release("click")
					
					
					Global.addwindow("res://scenes/apps/fileManager/WindowFileManager.tscn", "", [["MyComputer", "Desktop", n.get_child(1).text]])
					Global.ondesktop=false
			if n.type == "document":
			
				if Input.is_action_just_pressed("click"):
					Input.action_release("click")
					
					var file = FileAccess.open(dirstring + n.get_child(1).text, FileAccess.READ)
					var content = file.get_as_text()
					Global.addwindow("res://scenes/apps/notepad/notepad.tscn", n.get_child(1).text, [content, true])
					Global.ondesktop=false



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
		$GridContainer.add_child(inst)

	for dirs: String in dir.get_directories():
		#var resource := load(dir.get_current_dir() + "/" + file)
		var inst = icon.instantiate()
		inst.get_child(0).play("folder")
		inst.type = "folder"
		inst.get_child(1).text = str(dirs)
		$GridContainer.add_child(inst)
		print(dirs)
