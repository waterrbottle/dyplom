extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_parent().get_parent().get_parent().active:
		$AudioStreamPlayer.stop()
	else:
		if $AudioStreamPlayer.playing == false:
			$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
