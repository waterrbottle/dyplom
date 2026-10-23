extends Node2D

var texts = ["hi, im stamper.", 
"well not yet bc im clippy, but the image will be changed to a stamper soon.",
"welcome to the prototype of...",
"CRASHIN OUT! The Prototype of The Prototype. ",
"i will be your guide.",
"and ill help you move around the system.",
"you are the little red guy on your desktop.",
"you can move around using A and D or arrow keys.",
"you can jump by clcking W, SPACE or UP arrow.",
"you can dash down by clicking S or DOWN arrow.",
"you can use your ATTACK by pressing E.",
"you attack to the side you are currently facing.",
"you can also open files on your desktop using your mouse...",
"just like on a real computer, you smart little boy!",
"or girl or other.",
"you can now mess around and look into the folders.",
"maybe, if you arent blind, you can see that one of the folders...",
"IS FLICKERING. go ahead, click it!",
"you see, this folder is corrupted by the mysterious virus.",
"and it is Your job to fix it.",
"you can view the contents of the folder by clicking VIEW CONTENTS.",
"(wow thats clever!)",
"or you can go inside and fight the source of the coruuption.",
"your goal is to uncorrupt all the files inside that folder.",
"by punching the SH!T out of them.",
"well sorry but, i have to go now... bye!"] #,
#"im gong to a party with my friend, Paper. im gonna stamp him so hard!"]
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("text")
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("enter"):
		if index < texts.size()-1:
			$ColorRect/Label.visible_characters=0
			
			index += 1
			$ColorRect/Label.text = texts[index]
			$AnimationPlayer.play("text")
			$AudioStreamPlayer.play()
		else:
			get_parent().get_parent().get_parent().queue_free()
