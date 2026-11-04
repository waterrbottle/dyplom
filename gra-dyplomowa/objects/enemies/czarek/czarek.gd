extends CharacterBody2D

@export var EnemyStats: Resource
@export_enum("normal", "lobotomized") var type = ""

var particles = []
func _ready() -> void:
	if type == "lobotomized":
		$Stats.entity = "zlobotomizowany " + $Stats.entity
		$Panel.hide()
		$extentions/movement/MovementDasher.active = false

func _process(delta: float) -> void:
	if EnemyStats.health <= 0:
		queue_free()
	
	for n in particles:
		n -= delta
		if n < 0:
			$particles.get_child(n).queue_free()
			particles.remove_at(n)

func got_dmg(DamageType: String):
	if DamageType == "item":
		var inst = $CPUParticles2D.duplicate()
		inst.emitting = true
		$particles.add_child(inst)
		particles.append(3)
		$CPUParticles2D.emitting = true
