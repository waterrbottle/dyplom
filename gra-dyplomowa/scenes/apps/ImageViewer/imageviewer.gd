extends Node2D
var texturepath = "user://icon.svg"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func loadtexture():
	if texturepath != "":
		loadc()

func load_image_manually(path: String) -> ImageTexture:
	if not FileAccess.file_exists(path):
		Global.addwindow("uid://8ogs475b2e7p","",["invalid path.", true], null)
		return null
		
	# 1. Load the raw data into an Image object
	var img = Image.load_from_file(path)
	if img == null:
		Global.addwindow("uid://8ogs475b2e7p","",["no image.", true], null)
		return null
		
	# 2. Convert that Image into a Texture so Godot can render it
	var texture = ImageTexture.create_from_image(img)
	return texture

func loadc():
	print(texturepath)
	$CanvasLayer/TextureRect.texture = load_image_manually(texturepath)
	var size = $CanvasLayer/TextureRect.texture.get_size()
	
	var dzielnik = 1
	var checksize = size.x
	
	if size.y > size.x:
		checksize = size.y
	if checksize > 600:
		print(size)
		dzielnik = 1+ checksize/600
		size /= dzielnik
		print(size)
	checksize = size.x
	
	var mnoznik = 1
	if size.y < size.x:
		checksize = size.y
	if checksize < 50:
		mnoznik = 1+ 50/checksize
		size *= mnoznik
	#if size.y > 500:
	#	dzielnik = 1+ size.y/500
	#	size /= dzielnik
		

	#var mnoznik = 1
	#if size.x < 100:
	#	mnoznik = 1+ 100/size.x
	#	size.x *= mnoznik
	#if size.y < 100:
	#	mnoznik = 1+ 100/size.y
	#	size.y *= mnoznik
	get_parent().get_parent().get_parent().updatesize(size)
	$CanvasLayer/checker.show()
	$CanvasLayer/TextureRect.show()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
