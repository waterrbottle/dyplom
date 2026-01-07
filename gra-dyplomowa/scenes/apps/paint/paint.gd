extends Node2D

var img = null
var prevposition = Vector2(0,0)
var drawpos = Vector2(0,0)
var candraw = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	img = Image.create(756,512,false,Image.FORMAT_RGBA8)
	img.fill_rect(Rect2i(Vector2(0,0),Vector2(756,512)), Color.WHITE)
	
	%texture.texture = ImageTexture.create_from_image(img)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$paintui/Control.scale = Vector2(%zoomslider.value,%zoomslider.value)
	if Input.is_action_just_pressed("click"):
		drawpos = (get_global_mouse_position() - ($paintui/Control.position + %texture.position*$paintui/Control.scale) ) / $paintui/Control.scale
		prevposition = drawpos
		candraw = true
	if Input.is_action_just_released("click"):
		candraw = false

	if candraw == true:
		if $paintui/paintui/colcheck.is_pressed():
			print(prevposition)
			drawpos = (get_global_mouse_position() - ($paintui/Control.position + %texture.position*$paintui/Control.scale) ) / $paintui/Control.scale
			line_fill(drawpos,50.0,%sizeslider.value)
		
			%texture.texture = ImageTexture.create_from_image(img)
			prevposition = drawpos

func line_fill(pos:Vector2, amount:float,size:int):

	var diffx = pos.x - prevposition.x
	var diffy = pos.y - prevposition.y


	for i in range(amount):
		
		var valx = prevposition.x + (i/amount)*diffx 
		#print("rep: ", str(prevposition.x), str(i/diffx))
		var valy = prevposition.y + (i/amount)*diffy 
		if diffx == 0.0:
			valx=pos.x
		if diffy == 0.0:
			valy=pos.y
		img.fill_rect(Rect2i(Vector2((valx - size/2.0),valy - size/2.0),Vector2(size,size)), Color.RED)
		
