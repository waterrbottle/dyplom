extends Node
var display = true
@export var holdstate : Node
@export var itemstate : RigidBody2D
@export var parent : Node
@export var canPickup = false
@export var canThrow = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:


	if display == true:
		holdstate.show()
		itemstate.hide()
		itemstate.freeze=true
		itemstate.position=Vector2(0,0)
	else:
		
		holdstate.hide()
		itemstate.show()
		itemstate.freeze=false
func spawn(vel):
	itemstate.freeze=false
	display=false
	if vel.y> 0:
		vel.y *= -0.5
	itemstate.apply_central_impulse(vel)
	
func _physics_process(delta: float) -> void:
	if itemstate.linear_velocity.length() > 1000:
		itemstate.linear_velocity /= 1.1
