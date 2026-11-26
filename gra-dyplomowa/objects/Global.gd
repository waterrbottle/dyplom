extends Node
var playerloc = "window"
var ondesktop = true
var playervars = {"health": 100, "position": Vector2(0,0), "scale": Vector2(1,1)}
var quicktasks = ["where", "am", "i"]
var quicktasklock = false
var qtquueue = []
var qtopen = false
var activetype =""
var lockinput = false
var item = ""
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
	add_item("key")
	pass # Replace with function body.

func add_item(itemm):
	get_tree().call_group("player", "add_item", itemm)
	item = itemm

func updatetasks(tasks):
	get_node("/root/MyComputer/taskwindow").updateglobal(tasks)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#print(lockinput)
	var focus_owner = get_viewport().gui_get_focus_owner()
	
	# Check if anything actually has focus
	if is_instance_valid(focus_owner):
		# We check for LineEdit (Chat) and TextEdit (Large text blocks)
		if focus_owner is LineEdit or focus_owner is TextEdit:
			lockinput = true
		else:
			# Something else is focused (like a button), usually safe to unlock
			lockinput = false
	else:
		# No UI element is focused
		lockinput = false
	do_something()
	
	if playervars["health"] < 1:
		if !has_node("/root/MyComputer/Windows"):
			addwindow({"scene": "uid://8ogs475b2e7p", "name": "Data Overflow", "data": {"text": "you run out of lives", "bug": false, "image": "uid://tks5bgimi0am" }, "loc": null})
			addwindow({"scene": "uid://8ogs475b2e7p", "name": "info", "data": {"text": "since u in scene mode lives reset", "bug": false, "image": "uid://bn4l23n5c0444" }, "loc": null})

			playervars["health"] = 100
			return
		for n in get_node("/root/MyComputer/Windows").get_children():
			if n.appscene.get_node("Leveldata").type == "level":
				n.queue_free()
		addwindow({"scene": "uid://8ogs475b2e7p", "name": "Data Overflow", "data": {"text": "you run out of lives", "bug": false, "image": "uid://tks5bgimi0am" }, "loc": null})
		get_node("/root/MyComputer/Player").set_deferred("active", true)
		ondesktop=true

		playervars["health"] = 100

func addwindow(windowsetup: Dictionary):

	var scn = load("res://objects/TheWindowSystem/windowUI.tscn")
	var inst = scn.instantiate()
	inst.scene = windowsetup["scene"]
	inst.nameoverwrite = windowsetup["name"]
	inst.front = true
	inst.get_child(0).position = get_viewport().get_visible_rect().size/2 - inst.get_child(0).size /2
	
	print("opening app -> ", windowsetup["scene"])
	inst.spawnapp()
	if inst.appscene != null:
		if "contentdata" in inst.appscene:
			inst.appscene.contentdata = windowsetup["data"]
	
		#inst.appscene.get_child(0).content = content




	
	if has_node("/root/MyComputer/Windows"):
		if windowsetup["loc"] == null:
			get_node("/root/MyComputer/Windows").add_child.call_deferred(inst)
		else:
			windowsetup["loc"].add_child.call_deferred(inst)
	else:
		print("adding window")
		inst.position = playervars["position"]
		get_node("/root").get_child(-1).add_child.call_deferred(inst)
	
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
	#addwindow("res://scenes/apps/sysmessenger/sysmessenger.tscn", "", [error_string(e) + ". Error code: "+ str(e),true])
	print(path)
	remove_recursive(path)

	get_node("/root/MyComputer/DesktopFiles").update()
	for n in get_node("/root/MyComputer/Windows").get_children():
		if n.scene == "res://scenes/apps/fileManager/WindowFileManager.tscn":
			n.appscene.update()

func remove_recursive(path: String) -> Error:
	var dir = DirAccess.open(path)
	if not dir:
		bug("cant delete. error: " + error_string(DirAccess.get_open_error()))
		
		return DirAccess.get_open_error()

	# Start reading the contents
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path = path.path_join(file_name)
			if dir.current_is_dir():
				# It's a folder, recurse into it
				var err = remove_recursive(full_path)
				if err != OK:
					return err
			else:
				# It's a file, delete it
				var err = DirAccess.remove_absolute(full_path)
				if err != OK:
					return err
		file_name = dir.get_next()

	# The folder is now empty, delete the folder itself
	return DirAccess.remove_absolute(path)

func bug(txt):
	addwindow({"scene": "uid://8ogs475b2e7p", 
	"name": "crashin out bug - please report", 
	"data": {"image": "uid://d12eulhof6erx", "text": txt, "bug":true},
	"loc": null})
