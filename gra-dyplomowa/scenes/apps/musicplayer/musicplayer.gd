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
	print(musicload)
	if musicload != "":
		if musicload.get_extension() == "mp3":
			load_mp3_manually(musicload)
		elif musicload.get_extension() == "wav":
			
			load_wav_manually(musicload)
			$AudioStreamPlayer.stream = load_wav_manually(musicload)
			$CanvasLayer/Control/HBoxContainer/HSlider.max_value = $AudioStreamPlayer.stream.get_length()
			$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musictitle.text = musicname
		else:
			Global.addwindow("uid://8ogs475b2e7p","",{"text": "unrecognized file ext", "bug": true}, null)

	else:
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "no path", "bug": true}, null)

func load_mp3_manually(path: String):

	if not FileAccess.file_exists(path):
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "stream does not exist", "bug": true}, null)
		
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "error opening music file", "bug": true}, null)
		

	var bytes = file.get_buffer(file.get_length())
	
	var stream = AudioStreamMP3.new()
	
	stream.data = bytes
	$AudioStreamPlayer.stream = stream
	$CanvasLayer/Control/HBoxContainer/HSlider.max_value = $AudioStreamPlayer.stream.get_length()
	$CanvasLayer/Control/Panel3/ColorRect/VBoxContainer/musictitle.text = musicname

 
func load_wav_manually(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file: return null
	
	var bytes = file.get_buffer(file.get_length())
	var stream = AudioStreamWAV.new()
	
	var offset = 12
	var bits = 0
	var raw_data = PackedByteArray()

	while offset < bytes.size() - 8:
		var chunk_id = bytes.slice(offset, offset + 4).get_string_from_ascii()
		var chunk_size = bytes.decode_u32(offset + 4)
		var chunk_start = offset + 8
		
		if chunk_id == "fmt ":
			var compression_code = bytes.decode_u16(chunk_start)
			if compression_code != 1 and compression_code != 3:
				push_error("Not a PCM WAV (Compression: %d)" % compression_code)
				return null
				
			var channels = bytes.decode_u16(chunk_start + 2)
			stream.stereo = (channels == 2)
			stream.mix_rate = bytes.decode_u32(chunk_start + 4)
			bits = bytes.decode_u16(chunk_start + 14)
			
		elif chunk_id == "data":
			raw_data = bytes.slice(chunk_start, chunk_start + chunk_size)
		
		offset += 8 + chunk_size

	# --- THE CONVERSION LOGIC ---
	if bits == 16:
		stream.format = AudioStreamWAV.FORMAT_16_BITS
		stream.data = raw_data
	elif bits == 24:
		stream.format = AudioStreamWAV.FORMAT_16_BITS
		var converted = PackedByteArray()
		converted.resize(raw_data.size() / 3 * 2)
		
		var j = 0
		for i in range(0, raw_data.size() - 2, 3):
			# WAV is Little Endian. 24-bit is: [Low] [Mid] [High]
			# We want the Mid and High bytes to make a 16-bit sample.
			converted[j] = raw_data[i + 1]
			converted[j + 1] = raw_data[i + 2]
			j += 2
		stream.data = converted
	elif bits == 8:
		stream.format = AudioStreamWAV.FORMAT_8_BITS
		stream.data = raw_data
	else:
		push_error("Unsupported bit depth: %d" % bits)
		return null

	return stream


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
	
