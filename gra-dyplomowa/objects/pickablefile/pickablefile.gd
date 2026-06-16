extends Node2D
@export var fileopenpath = ""
@export var filesunlocked = ""
@export var iconoverride = ""
var health = 5
@export var win = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.monitorable=true
	if iconoverride != "":
		$Node2D/AnimatedSprite2D.play(iconoverride)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_area_2d_area_entered(area: Area2D) -> void:

	if area.is_in_group("fist"):

		print("object hit")
		$AnimationPlayer.play("hit")
		health -= 1
		
		if health == 0:
			$AnimationPlayer.play("die")
	
	


func readfolderdata(fp):
	print(fp)
	var json_string = ( (fp.get_as_text()) )
	
	
	var json = JSON.new()
	var error = json.parse(json_string)
	print(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			print(data_received) # Prints the array.
			return data_received
			
		else:
			return null
			print("Unexpected data")
	else:
		return null
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func open():
	var o = FileAccess.open(fileopenpath + "filedata.json", FileAccess.READ)
	print("____________________---_________")
	var cf = (readfolderdata(o))
	if cf["corruptedfiles"].has(filesunlocked):
		print("REMOVING OLD FILE")
		cf["corruptedfiles"].erase(filesunlocked)
	var d = FileAccess.open(fileopenpath + "filedata.json", FileAccess.WRITE)
	d.store_string(JSON.stringify(cf))

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		
		open()
		Global.addwindow("res://scenes/apps/fileManager/WindowFileManager.tscn", "", {"dirstring": fileopenpath},null)
		if win == true:
			Global.addwindow("uid://8ogs475b2e7p", "good news", {"text": "LEVEL CLEARED!", "image": load("uid://c15a6gp0qy7g6")}, null)
		queue_free()
		
