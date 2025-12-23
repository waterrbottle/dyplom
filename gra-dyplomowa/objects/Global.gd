extends Node
var playerloc = "window"
var ondesktop = true
var playervars = {"health": 100, "position": Vector2(0,0)}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
	
	
