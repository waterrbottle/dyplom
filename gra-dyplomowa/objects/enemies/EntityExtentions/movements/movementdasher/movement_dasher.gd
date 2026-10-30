extends Node
@export var entity: CharacterBody2D
@export var chargebar: ProgressBar
@export var active = true
@export_range(0, 1000) var gravity = 30.0
@export_range(0, 10000) var chargePower = 1000.0
@export_range(1, 2) var slipperiness = 1.05
@export_category("jumping")
@export var jumpOnCharge = false
@export var jumpPower = -1000
@export var jumpOnlyWhenPlayerAbove = true
@export var doNegativeJump = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chargebar.max_value = $dashtimer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	entity.velocity.y += gravity
	entity.move_and_slide()
	entity.velocity.x /= slipperiness

func _process(delta: float) -> void:
	chargebar.value = chargebar.max_value - $dashtimer.time_left

func _on_dashtimer_timeout() -> void:
	if active == false:
		return
	if Global.playervars["position"].x < entity.global_position.x:
		entity.velocity.x += -chargePower
	else:
		entity.velocity.x += chargePower
	if jumpOnCharge == true:
		if jumpOnlyWhenPlayerAbove == false:
			if doNegativeJump == false:
				entity.velocity.y = jumpPower
			else:
				if Global.playervars["position"].y < entity.global_position.y:
					entity.velocity.y = jumpPower
				else:
					entity.velocity.y = -jumpPower
		else:
			if doNegativeJump == false:
				if entity.global_position.y > Global.playervars["position"].y:
					entity.velocity.y = jumpPower
			else:
				if Global.playervars["position"].y < entity.global_position.y:
					entity.velocity.y = jumpPower
				else:
					entity.velocity.y = -jumpPower
			
	$dashtimer.start()
