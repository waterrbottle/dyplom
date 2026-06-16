extends Node2D
@export var fileopenpath = ""
var health = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.monitorable=true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_area_2d_area_entered(area: Area2D) -> void:

	if area.is_in_group("fist"):

		print("object hit")
		$AnimationPlayer.play("hit")
		health -= 1
		
	if health == 0:
		$AnimationPlayer.play("die")
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		Global.addwindow("res://scenes/apps/fileManager/WindowFileManager.tscn", "", {"dirstring": fileopenpath},null)
		queue_free()
