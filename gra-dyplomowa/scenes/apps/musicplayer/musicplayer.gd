extends Node2D
var musicload := ""
var open=false
var musicname = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if musicload != "":
		$AudioStreamPlayer.stream = load(musicload)
		$CanvasLayer/Control/HBoxContainer/HSlider.max_value = $AudioStreamPlayer.stream.get_length()
		$CanvasLayer/Control/Panel3/ColorRect/Label.text = musicname


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $CanvasLayer/Control/HBoxContainer/HSlider/Button.is_pressed() == false:
		
		$CanvasLayer/Control/HBoxContainer/HSlider.value = $AudioStreamPlayer.get_playback_position()
	else:
		pass


func _on_play_pressed() -> void:
	if open == false:
		$AudioStreamPlayer.play()
		open=true
	$AudioStreamPlayer.stream_paused=false


func _on_pause_pressed() -> void:
	$AudioStreamPlayer.stream_paused=true


func _on_button_button_up() -> void:
	$AudioStreamPlayer.play($CanvasLayer/Control/HBoxContainer/HSlider.value)


func _on_audio_stream_player_finished() -> void:
	open=false
