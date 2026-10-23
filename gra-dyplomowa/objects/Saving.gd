extends Node


func copy_folder_recursive(from_path: String, to_path: String) -> void:
	if not DirAccess.dir_exists_absolute(to_path):
		DirAccess.make_dir_recursive_absolute(to_path)

	var dir = DirAccess.open(from_path)
	if not dir:
		print("Failed to open directory: ", from_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	# Keep a list of files we've processed so we don't process 
	# the raw file AND its .import duplicate file in the editor.
	var processed_files = []

	while file_name != "":
		if file_name != "." and file_name != "..":
			var old_path = from_path + "/" + file_name
			
			if dir.current_is_dir():
				copy_folder_recursive(old_path, to_path + "/" + file_name)
			else:
				# Strip Godot's hidden extensions to get the "real" file name
				var true_name = file_name.replace(".import", "").replace(".remap", "")
				
				# If we haven't copied this exact file yet...
				if not true_name in processed_files:
					processed_files.append(true_name)
					
					var load_path = from_path + "/" + true_name
					var save_path = to_path + "/" + true_name
					var ext = true_name.get_extension().to_lower()
					
					# --- RESOURCES: Let Godot unpack them natively from memory ---
					if ext in ["png", "jpg", "jpeg", "webp", "wav", "mp3", "ogg"]:
						var resource = load(load_path)
						if resource:
							# Safely extract WAVs without static noise
							if ext == "wav" and resource is AudioStreamWAV:
								resource.save_to_wav(save_path)
							
							# Extract MP3 and OGG bytes
							elif ext in ["mp3", "ogg"]:
								if resource is AudioStreamMP3:
									var f = FileAccess.open(save_path, FileAccess.WRITE)
									if f:
										f.store_buffer(resource.data)
										f.close()
								elif resource is AudioStreamOggVorbis:
									ResourceSaver.save(resource, save_path)
									
							# Extract Images
							elif resource is Texture2D:
								var img = resource.get_image()
								if ext == "png": img.save_png(save_path)
								elif ext in ["jpg", "jpeg"]: img.save_jpg(save_path)
								elif ext == "webp": img.save_webp(save_path)
						else:
							print("Failed to load resource data: ", load_path)
							
					# --- NON-RESOURCES: Copy raw bytes (Text, JSON, Data) ---
					else:
						var file_in = FileAccess.open(old_path, FileAccess.READ)
						if file_in:
							var buffer = file_in.get_buffer(file_in.get_length())
							file_in.close()
							
							var file_out = FileAccess.open(save_path, FileAccess.WRITE)
							if file_out:
								file_out.store_buffer(buffer)
								file_out.close()
						else:
							print("Failed to read raw file bytes: ", old_path)
							
		file_name = dir.get_next()
func _ready():
	copy_folder_recursive("res://MyComputer", "user://MyComputer")


func save_file(content):
	var file = FileAccess.open("user://test.txt", FileAccess.WRITE)
	print(file)
	

func load_file():
	var file = FileAccess.open("res://test.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
