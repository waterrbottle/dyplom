extends Node2D
var texturepath = "res://icon.svg"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func loadtexture():
	if texturepath != "":
		loadc()


func loadc():
	$CanvasLayer/TextureRect.texture = load(texturepath)
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
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
