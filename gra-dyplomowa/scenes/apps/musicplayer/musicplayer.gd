extends Node2D
var musicload := ""
var open=false
var musicname = ""
var spectrum = AudioEffectSpectrumAnalyzerInstance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spectrum=AudioServer.get_bus_effect_instance(0,0)
	if musicload != "":
		$AudioStreamPlayer.stream = load(musicload)
		$CanvasLayer/Control/HBoxContainer/HSlider.max_value = $AudioStreamPlayer.stream.get_length()
		$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musictitle.text = musicname


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musicduration.text = str("duration: ", floor($AudioStreamPlayer.get_playback_position()*10)/10, "/", floor( $AudioStreamPlayer.stream.get_length()*10)/10 )

	$CanvasLayer/Control/Control/Line2D.clear_points()
	for i in range(270):
		$CanvasLayer/Control/Control/Line2D.add_point(Vector2(i-115,spectrum.get_magnitude_for_frequency_range(i*10 - 50, i*10+1 - 50, 1).x*100 + 60))
	if $CanvasLayer/Control/HBoxContainer/HSlider/Button.is_pressed() == false:
		
		$CanvasLayer/Control/HBoxContainer/HSlider.value = $AudioStreamPlayer.get_playback_position()
	else:
		if $Timer.time_left < 0.01:
			$AudioStreamPlayer.play($CanvasLayer/Control/HBoxContainer/HSlider.value)


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
