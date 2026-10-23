extends RigidBody2D

var dragmode = false
var stiffness = 800.0  
@export var dampng: float = 40.0     # Stops it from bouncing like crazy (acts like friction)
@export var offset: Vector2 = Vector2(0, 0) # WHERE it grabs the object (0, -30 means grabbing it by the top)
var mute = false
var savedoffset = Vector2(0,0)

func load_image_manually(path: String) -> ImageTexture:
	if not FileAccess.file_exists(path):
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "invalid path.","bug": true}, null)
		return null
		

	var img = Image.load_from_file(path)
	if img == null:
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "no image.","bug": true}, null)
		return null
		

	var texture = ImageTexture.create_from_image(img)
	return texture
func _ready() -> void:

	loadsettings()
func loadsettings() -> void:

	var path = "user://MyComputer/appdata/adachirei.cxe/settings.txt"
	if FileAccess.file_exists(path):
		
		var settings = FileAccess.open(path, FileAccess.READ)
		
		if settings != null:
			var json_text = settings.get_as_text()
			var dict = JSON.parse_string(json_text)
			if dict != null:
				if dict["bounciness"] is int or dict["bounciness"] is float:
					physics_material_override.bounce = dict["bounciness"]
				if dict["gravity"] is int or dict["gravity"] is float:
					gravity_scale = dict["gravity"]
				if dict["mass"] is int or dict["mass"] is float:
					mass = dict["mass"]
				if dict["customname"] is String:
					if dict["customname"] != "":
						$Stats.entity = dict["customname"] + ".cxe"
				
				if dict["imageoverride"] is String:
					if dict["imageoverride"] != "":
						print("loading custom image")

						$Sprite2D.texture = load_image_manually(dict["imageoverride"])
						if $Sprite2D.texture == null:
							$Sprite2D.texture = load("uid://c4apgwomfwmag")
				if dict["mute"] is bool:
					mute = dict["mute"]
						

						
				
			else:
				Global.addwindow("uid://8ogs475b2e7p","",{"text": "dictionary is null. maybe you made a typo?.","bug": false},null)
				

		else:
			Global.addwindow("uid://8ogs475b2e7p","",{"text": "cant open settings file.","bug": false},null)
	else:
		Global.addwindow("uid://8ogs475b2e7p","",{"text": "YOU DELETED SETTINGS DATA :( add it back at: user://MyComputer/appdata/adachirei.cxe/settings.txt","bug": false},null)
	var w =  $Sprite2D.texture.get_width()
	var h = $Sprite2D.texture.get_height()
	var max_dim = max(w, h)
	if max_dim > 150:
		var scale_factor = 150.0 / max_dim
	

		$Sprite2D.size.x = w * scale_factor
		$Sprite2D.size.y = h * scale_factor
	else:
		$Sprite2D.size.x = w
		$Sprite2D.size.y = h
	$Sprite2D.position -= $Sprite2D.size/2
	$CollisionShape2D.shape.size = $Sprite2D.size / 1.1
	
func _process(delta: float) -> void:
	if position.x > get_viewport_rect().size.x:
		queue_free()
	if position.y > get_viewport_rect().size.y:
		queue_free()
	if position.y < 0:
		queue_free()

	var local_x_vel = linear_velocity.dot(global_transform.x.normalized())
	var local_y_vel = linear_velocity.dot(global_transform.y.normalized())

	var multix = abs(local_x_vel) / 3000.0
	var multiy = abs(local_y_vel) / 3000.0

	multix = min(multix, 0.5)
	multiy = min(multiy, 0.5)

	var target_scale_x = 1.0
	var target_scale_y = 1.0

	if multix > multiy:
		target_scale_x = 1.0 + multix
		target_scale_y = 1.0 - multix
	else:
		target_scale_y = 1.0 + multiy
		target_scale_x = 1.0 - multiy


	$Sprite2D.scale.x = lerp($Sprite2D.scale.x, target_scale_x, 15.0 * delta)
	$Sprite2D.scale.y = lerp($Sprite2D.scale.y, target_scale_y, 15.0 * delta)
	if mute == false:
		$AudioStreamPlayer.pitch_scale =  0.5 + linear_velocity.length() / 5000
		if $AudioStreamPlayer.pitch_scale < 1:
			$AudioStreamPlayer.pitch_scale = 1
		if linear_velocity.length() > 5000:
		
			$AudioStreamPlayer.volume_linear = 1
		else:
			$AudioStreamPlayer.volume_linear = 1 - (5000 -linear_velocity.length())/5000
	else:
		$AudioStreamPlayer.volume_linear = 0
	# Keep your UI updated visually
	$Stats.position = position + Vector2(0, -75)
	
	if dragmode and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragmode = false

# _integrate_forces is the ONLY safe place to manipulate RigidBody physics directly
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dragmode:
		
		offset = savedoffset
		var mouse_pos = get_global_mouse_position()
		

		var current_grab_point = offset.rotated(rotation)
		var grab_point_global = global_position + current_grab_point
		
		# 2. Calculate the distance from the hook to the mouse
		var displacement = mouse_pos - grab_point_global
		
		var spring_force = (displacement * stiffness) - (state.linear_velocity * dampng)
		
		# 4. Apply the force exactly at the grab point! 
		# Because we apply it off-center, Godot's physics engine naturally tilts and swings the object.
		state.apply_force(spring_force, current_grab_point)
	

func _on_button_pressed() -> void:
	pass

func _on_button_button_down() -> void:
	dragmode = true
	sleeping=false
	print("startdrag")
	savedoffset = get_local_mouse_position()
