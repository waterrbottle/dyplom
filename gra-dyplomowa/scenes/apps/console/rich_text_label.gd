extends RichTextLabel


var log_path = "user://logs/godot.log"
var file : FileAccess
var last_pos = 0


func _ready() -> void:
	# 1. Initialize the UI
	bbcode_enabled = true
	append_text("[color=green]\n")
	
	# 2. Setup a Timer to poll the file (calling it every 0.2 seconds)
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.timeout.connect(_update_logs)
	timer.start()
	
	
	
	

func _update_logs() -> void:
	if not file:
		if FileAccess.file_exists(log_path):
			file = FileAccess.open(log_path, FileAccess.READ)
		return
	var current_len = file.get_length()
	
	# If the file was cleared or rotated, reset
	if current_len < last_pos:
		last_pos = 0
		
	if current_len > last_pos:
		file.seek(last_pos)
		
		# Read only the NEW bytes as a buffer
		var buffer = file.get_buffer(current_len - last_pos)
		
		# Convert buffer to string safely
		var new_content = buffer.get_string_from_utf8()
		

		if new_content == "" and buffer.size() > 0:
			new_content = buffer.get_string_from_ascii()

		append_text(new_content)
		last_pos = current_len
		
		# Auto-scroll
		var v_scroll = get_v_scroll_bar()
		v_scroll.value = v_scroll.max_value
