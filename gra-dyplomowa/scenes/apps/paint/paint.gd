extends Node2D
var colors = [Color(0.0, 1.0, 0.0, 1.0), Color(1.0, 1.0, 0.0, 1.0),  Color(1.0, 0.0, 0.0, 1.0),  Color(0.0, 0.0, 1.0, 1.0), Color(0.0, 0.75, 1.0, 1.0), Color(0.6, 0.0, 1.0, 1.0), Color(1.0, 0.517, 0.0, 1.0), Color(0.5, 0.5, 0.5, 1.0), Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 1.0)]
var img = null
var prevposition = Vector2(0,0)
var drawpos = Vector2(0,0)
var candraw = false
var color = Color(1.0, 0.0, 0.017, 1.0)
enum tools{pen, rubber, move, fill}
var tool = null
var startclick = Vector2(0,0)

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	Global.addwindow("res://scenes/apps/paint/newfile.tscn", "", [], $windows)
	%texture.hide()
	for n in $paintui/paintui/Panel3/VBoxContainer/GridContainer.get_children():
		n.get_child(0).color = colors[n.get_index()]
func createimg(isize: Vector2i) -> void:

	print(isize)
	tool = tools.pen
	
	img = Image.create(isize.x,isize.y,false,Image.FORMAT_RGBA8)
	img.fill_rect(Rect2i(Vector2(0,0),Vector2(isize.x,isize.y)), Color.WHITE)
	
	%texture.texture = ImageTexture.create_from_image(img)
	%texture.size = isize
	%texture.position = -isize/2
	%texture.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for n in $paintui/paintui/Panel3/VBoxContainer/GridContainer.get_children():
		if n.is_pressed():
			color = colors[n.get_index()]
	for n in $paintui/paintui/tools/VBoxContainer.get_children():
		if n.is_pressed():
			tool = n.get_index()
	if tool == tools.move:
		if Input.is_action_just_pressed("click"):
			startclick = %texture.position- get_local_mouse_position()
		if Input.is_action_pressed("click"):
			%texture.position =  (startclick + get_local_mouse_position())
	%maincolor.get_child(0).color = color
	$paintui/Control.scale = Vector2(%zoomslider.value,%zoomslider.value)
	if Input.is_action_just_pressed("click"):
		drawpos = (get_global_mouse_position() - ($paintui/Control.position + %texture.position*$paintui/Control.scale) ) / $paintui/Control.scale
		prevposition = drawpos
		candraw = true
	if Input.is_action_just_released("click"):
		candraw = false

	if candraw == true:
		if $paintui/paintui/colcheck.is_pressed():
			drawpos = (get_global_mouse_position() - ($paintui/Control.position + %texture.position*$paintui/Control.scale) ) / $paintui/Control.scale
			if tool == tools.pen or tool == tools.rubber:
				
				line_fill(drawpos,50.0,%sizeslider.value)
		
				
				
			if tool == tools.fill:
				if Input.is_action_just_pressed("click"):
					colorfill(drawpos)
			%texture.texture = ImageTexture.create_from_image(img)
			prevposition = drawpos
func colorfill(pos):
	var counter = 0
	var img_size = img.get_size()
	var startcolor = img.get_pixel(pos.x,pos.y)
	var flood: PackedVector2Array = [Vector2i(pos)]
	if startcolor == color:
		return
	while flood.size() > 0:
		var current = Vector2i(flood[-1])
		flood.remove_at(flood.size() - 1)
		
		if current.x < 0 or current.x >= img_size.x or current.y < 0 or current.y >= img_size.y:
			continue
		
		if img.get_pixel(current.x, current.y) == startcolor:
			img.set_pixel(current.x, current.y, color)
		
		# Add all 4 neighboring pixels to the list to check them next
			flood.append(Vector2i(current.x + 1, current.y))
			flood.append(Vector2i(current.x - 1, current.y))
			flood.append(Vector2i(current.x, current.y + 1))
			flood.append(Vector2i(current.x, current.y - 1))
		counter += 1
		if counter % 20000 == 0: # Every 2000 pixels processed...
			%texture.texture = ImageTexture.create_from_image(img)
			await get_tree().process_frame # ...pause for 1 frame to let the game render
	%texture.texture = ImageTexture.create_from_image(img)

func line_fill(pos:Vector2, amount:float,size:int):

	var diffx = pos.x - prevposition.x
	var diffy = pos.y - prevposition.y
	
	var collorov = color
	for i in range(amount):
		
		var valx = prevposition.x + (i/amount)*diffx 
		#print("rep: ", str(prevposition.x), str(i/diffx))
		var valy = prevposition.y + (i/amount)*diffy 
		if diffx == 0.0:
			valx=pos.x
		if diffy == 0.0:
			valy=pos.y
		if tool == tools.rubber:
			collorov = Color(0.0, 0.0, 0.0, 0.0)

		img.fill_rect(Rect2i(Vector2((valx - size/2.0),valy - size/2.0),Vector2(size,size)), collorov)
		

func save(img: Image, file_name: String) -> void:

	var save_path = file_name
	
	var error = img.save_png(save_path)
	if error != OK:
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "invalid path / invalid name. dont end the path on /.", "bug": true},null)
		Global.addwindow("uid://8ogs475b2e7p","",{"text": file_name + " - cant create file here","bug": true},null)

func savefile(name, path):
	save(img, "user://" + path + "/" + name + ".png")

func _on_savefileas_pressed() -> void:
	Global.addwindow("uid://bfpf6kh6ry4ad", "", [], $windows)


func _on_newfile_pressed() -> void:
	Global.addwindow("uid://bsxfdcsh3jv4k", "", [], $windows)
