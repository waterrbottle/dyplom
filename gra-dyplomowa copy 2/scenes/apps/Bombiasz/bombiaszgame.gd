extends Node2D
var bombaszsize = 13
var bbuton = load("res://scenes/apps/Bombiasz/bombiaszbutton.tscn")
var r = null
var wl = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Control/GridContainer.columns = bombaszsize
	for i in range(bombaszsize):
		for j in range(bombaszsize):
			
			var inst = bbuton.instantiate()
			var randi = randi_range(1,2)
			if i < 2:
				if randi == 1:
					inst.state = "fire"
			if i > bombaszsize-3:
				if randi == 1:
					inst.state = "fire"
			if j < 2:
				if randi == 1:
					inst.state = "fire"
			if j > bombaszsize-3:
				if randi == 1:
					inst.state = "fire"
			if i ==(bombaszsize-1)/2:
				if j == (bombaszsize-1)/2:
					inst.state = "bomb"
			$CanvasLayer/Control/GridContainer.add_child(inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$detect.position = get_global_mouse_position()
	for n in $CanvasLayer/Control/GridContainer.get_children():
		if n.state != "bomb":
			if n.inmouse == true:
				n.state = ""


func getbtn(i,j):
	r = null
	if i >= 0:
		if i <= bombaszsize-1:
			if j >= 0:
				if j <= bombaszsize-1:
					r = $CanvasLayer/Control/GridContainer.get_child(i*bombaszsize+j)
func _on_timer_timeout() -> void:
	var firecount = 0
	for i in range(bombaszsize):
		for j in range(bombaszsize):
			var n = $CanvasLayer/Control/GridContainer.get_child(i*bombaszsize+j)
			if n.state == "fire":
				firecount += 1
				var randi = randi_range(1,20)
				if randi == 1:
					
					getbtn(i+1,j)
					if r != null:
						r.state= "fire"
				if randi == 2:
					getbtn(i-1,j)
					if r != null:
						r.state= "fire"
				if randi == 3:
					getbtn(i,j+1)
					if r != null:
						r.state= "fire"
				if randi == 4:
					getbtn(i,j-1)
					if r != null:
						r.state= "fire"
			if i == (bombaszsize-1)/2:
				if j == (bombaszsize-1)/2:
					if n.state == "fire":
						if wl == "":
							$CanvasLayer2/ColorRect2/AnimationPlayer.play("infobar (2)")
							$CanvasLayer2/ColorRect2.color =  Color(1.0, 0.34, 0.34, 1.0)
							$CanvasLayer2/Label3.text = "the bomb has exploded!"
						wl = "lose"
	if firecount == 0:
		if wl == "":
			$CanvasLayer2/ColorRect2/AnimationPlayer.play("infobar (2)")
			$CanvasLayer2/ColorRect2.color = Color(0.214, 0.63, 0.242, 1.0)
			$CanvasLayer2/Label3.text = "hey u did it! bomb is yours!"
			Global.add_item("bomb")
		wl = "win"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.closewindow("node", get_parent().get_parent().get_parent())
