extends Node2D


func _ready() -> void:
	pass
	%consoletext.append_text( "[color=green]crasin out console. type help for help.")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		%consoletext.append_text("\n" +$CanvasLayer/Panel/LineEdit.text)
		%consoletext.append_text("\n" +command($CanvasLayer/Panel/LineEdit.text))
		$CanvasLayer/Panel/LineEdit.text=""
		


func command(text):
	if text =="help":
		return "i cant help you lol"
	else:
		return "unknown command"
