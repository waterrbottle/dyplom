extends Node

var timer = null

@export var entity: Node
@export_category("JUMPING")
@export var canjump=true
@export_range(0, 3000) var jumpheight = 700.0
@export var jumpfrequency = Vector2(0.5,1.5)
@export_category("WALKING")
@export_range(0, 50) var speedgain = 5.0
@export_range(0, 5000) var maxspeed = 500.0
@export_category("GRAVITY")
@export_range(0, 1000) var gravity = 30.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_tree().create_timer(randf_range(jumpfrequency.x,jumpfrequency.y))
	timer.timeout.connect(_on_timer_timeout2)

func _on_timer_timeout2():
	if canjump == true:
		if entity.is_on_floor():
			if entity.position.y > Global.playervars["position"].y + 30:
				entity.velocity.y = -jumpheight
	timer = get_tree().create_timer(randf_range(jumpfrequency.x,jumpfrequency.y))
	timer.timeout.connect(_on_timer_timeout2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if entity.position.x > Global.playervars["position"].x:
		entity.velocity.x += -speedgain
	else:
		entity.velocity.x += speedgain
	
	if abs(entity.velocity.x) > maxspeed:
		entity.velocity.x /= 1.1
	
	entity.velocity.y += gravity# += get_gravity() * 3
	entity.move_and_slide()
