extends Node2D
var musicload := ""
var open=false
var musicname = ""
var spectrum = AudioEffectSpectrumAnalyzerInstance
var loop = false
var texturesspeaker = [load("res://assets/images/ui/icons/musicplayer/glosnik_bez_paskow.png"),
load("res://assets/images/ui/icons/musicplayer/glosnik.png"),
 load("res://assets/images/ui/icons/musicplayer/glosnik_paski_2.png")]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spectrum=AudioServer.get_bus_effect_instance(0,0)
	if musicload != "":
		$AudioStreamPlayer.stream = load(musicload)
		$CanvasLayer/Control/HBoxContainer/HSlider.max_value = $AudioStreamPlayer.stream.get_length()
		$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musictitle.text = musicname


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	

	$AudioStreamPlayer.volume_linear = $CanvasLayer/Control/volume.value
	if loop == false:
		%looplabel.text = "loop off"
	if loop == true:
		%looplabel.text = "loop on"
	%volumelabel.text = "volume: " + str(int($CanvasLayer/Control/volume.value*100))
	if $AudioStreamPlayer.stream != null:
		$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musicduration.text = str("duration: ", floor($AudioStreamPlayer.get_playback_position()*10)/10, "/", floor( $AudioStreamPlayer.stream.get_length()*10)/10 )
	
	if $AudioStreamPlayer.playing==true:
		%Line2D.clear_points()
		for i in range(200):
			%Line2D.add_point(Vector2(i-85,spectrum.get_magnitude_for_frequency_range(i*10 - 0, i*10+1 - 0, 1).x*100 + 60))
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
	open=true


func _on_audio_stream_player_finished() -> void:
	open=false
	if loop == true:
		open=true
		$AudioStreamPlayer.play()


func _on_loop_pressed() -> void:
	if loop == false:
		loop = true
		return
	if loop == true:
		loop = false


func _on_volume_value_changed(value: float) -> void:
	if value > 0.79:
		$CanvasLayer/Control/volumetexture.texture = texturesspeaker[2]
	if value < 0.8:
		$CanvasLayer/Control/volumetexture.texture = texturesspeaker[1]
	if value < 0.1:
		$CanvasLayer/Control/volumetexture.texture = texturesspeaker[0]
	
