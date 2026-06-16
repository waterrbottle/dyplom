extends Node

var content = "computer exploded"
var bug = false
var buttonfunctions = [["ok", "close", {}]]
var img = load("uid://d12eulhof6erx")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/TextureRect.texture = img
	for l in buttonfunctions:
		var inst = $CanvasLayer/HBoxContainer/Button.duplicate()
		inst.text = l[0]
		inst.visible=true
		$CanvasLayer/HBoxContainer.add_child(inst)
	$CanvasLayer/HBoxContainer/Button.queue_free()

func close(data):

	get_parent().get_parent().get_parent().queue_free()

func open(data):
	Global.addwindow(data["scene"], "", data["content"], null)
	close(data)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if bug == true:
		$CanvasLayer/ColorRect.color = Color(1.0, 0.43, 0.43, 1.0)
	$CanvasLayer/Label.text = content
	get_parent().get_parent().get_parent().updatesize(Vector2($CanvasLayer/Label.size.x + 30, 100))
	for n in $CanvasLayer/HBoxContainer.get_children():
		if n.is_pressed():

			if Input.is_action_just_pressed("click"):
				if buttonfunctions[get_index()][1] == "close":
					
					close(buttonfunctions[n.get_index()-1][2])
				
				if buttonfunctions[get_index()][1] == "open":
					
					open(buttonfunctions[n.get_index()-1][2])
			n.disabled = true
			n.disabled = false
		
