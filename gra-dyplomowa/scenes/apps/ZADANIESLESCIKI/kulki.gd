extends Node3D

var e = []
var radius = 1
var o = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawnballs(1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	for n in $CSGBox3D.get_children():
		# e[n.get_index()-1]
		n.position.x = radius * sin(e[n.get_index()-1])
		n.position.y = radius * cos(e[n.get_index()-1]) 
		
		e[n.get_index()-1] += 0.01

		if fmod(e[n.get_index()-1],2*PI ) > 0 :
			if fmod(e[n.get_index()-1],2*PI ) < 0.1 :
				n.queue_free()
				e.remove_at(n.get_index()-1)





func _on_h_slider_value_changed(value: float) -> void:
	spawnballs(value)
	$CanvasLayer/Panel2/VBoxContainer/Label2.text = str(value)

func spawnballs(a):
	for n in $CSGBox3D.get_children():
		n.free()
	e = []
	
	for i in range(a):

		var inst = $ball.duplicate()
		inst.visible = true

		var angle = 360/a * i
		e.append((angle/180.0 * PI))
		$CSGBox3D.add_child(inst)

	
	

func _on_h_slider_2_value_changed(value: float) -> void:
	radius = value
	$CanvasLayer/Panel2/VBoxContainer/Label4.text = str(radius)
