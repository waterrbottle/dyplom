extends Node


# Called when the node enters the scene tree for the first time.



func copy_folder_recursive(from_path: String, to_path: String):
	# Ensure the destination directory exists
	if not DirAccess.dir_exists_absolute(to_path):
		DirAccess.make_dir_recursive_absolute(to_path)

	var dir = DirAccess.open(from_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if file_name != "." and file_name != "..":
				var old_file = from_path + "/" + file_name
				var new_file = to_path + "/" + file_name
				
				if dir.current_is_dir():
					# If it's a folder, call this function again (recursion)
					copy_folder_recursive(old_file, new_file)
				else:
					# If it's a file, copy it
					var error = dir.copy(old_file, new_file)
					if error != OK:
						print("Error copying file: ", file_name, " Error: ", error)
						
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: ", from_path)

# Example usage:
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
