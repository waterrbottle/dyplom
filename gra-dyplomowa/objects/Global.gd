extends Node
var playerloc = "window"
var ondesktop = true
var playervars = {"health": 100, "position": Vector2(0,0)}
var quicktasks = ["where", "am", "i"]
var quicktasklock = false
signal deferred

func wait_deferred() -> Signal:
	var deferred_signal := Signal(deferred)
	deferred_signal.emit.call_deferred()
	return deferred_signal

func do_something():
	# Stuff happens here
	await wait_deferred()
	quicktasklock=false
	# Stuff happens here at the end of the current frame
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.







func updatetasks(tasks):
	get_node("/root/MyComputer/taskwindow").updatetasks(tasks)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	do_something()
	if playervars["health"] < 1:
		for n in get_node("/root/MyComputer/Windows").get_children():
			if n.appscene.get_node("Leveldata").type == "level":
				n.queue_free()
		playervars["health"] = 100

func addwindow(scene: String, namee, content):

	var scn = load("res://objects/TheWindowSystem/windowUI.tscn")
	var inst = scn.instantiate()
	inst.scene = scene
	inst.nameoverwrite = namee
	inst.front = true
	inst.get_child(0).position = get_viewport().get_visible_rect().size/2 - inst.get_child(0).size /2
	if scene == "res://scenes/apps/fileManager/WindowFileManager.tscn":
		inst.spawnapp()
		inst.appscene.dirlist = content[0]
		inst.appscene.updatedirstring()
	if scene == "res://scenes/apps/notepad/notepad.tscn":
		inst.spawnapp()
		if inst.appvalid == true:
			inst.appscene.content = content
		#inst.appscene.get_child(0).content = content
	if scene == "res://scenes/apps/notepad/notepad.tscn":
		pass
	if scene == "res://scenes/apps/sysmessenger/sysmessenger.tscn":
		
		inst.spawnapp()
		inst.appscene.content = content[0]
		inst.appscene.bug = content[1]
	if scene == "res://scenes/apps/ImageViewer/imageviewer.tscn":
		inst.spawnapp()
		inst.appscene.texturepath = content[0]
		inst.appscene.loadtexture()
	if scene == "res://scenes/apps/musicplayer/musicplayer.tscn":
		inst.spawnapp()
		inst.appscene.musicload = content[0]
		inst.appscene.musicname = content[1]
	get_node("/root/MyComputer/Windows").add_child.call_deferred(inst)
	
func closewindow(closetype, value):
	if closetype == "node":
		value.queue_free()
	if closetype == "type":
		for n in get_node("/root/MyComputer/Windows").get_children():
			if n.scene == "value":
				queue_free()
	if closetype == "all":
		for n in get_node("/root/MyComputer/Windows").get_children():
			n.queue_free()

func addfolder(path,value):
	var dir = DirAccess.open(path)
	dir.make_dir(value)
	get_node("/root/MyComputer/DesktopFiles").update()

func renamefile(old,new):
	pass

func deletefolder(path):
	print("pathHHH")
	print(path)
	#var dir = DirAccess.open(path)
	#DirAccess.remove_absolute(path)
	print(DirAccess.dir_exists_absolute(path))

	DirAccess.remove_absolute(path)
	
	#	addwindow("res://scenes/apps/sysmessenger/sysmessenger.tscn", "", [path + " doesnt exist?", true])

	get_node("/root/MyComputer/DesktopFiles").update()
