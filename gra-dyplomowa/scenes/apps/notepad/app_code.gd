extends Node2D
var content = ["",false]

# notatki: 
# SKRYPT aplikacji notepad 
# content -> metadata do otwierania aplikacji. content[0] to zawartosc
# notatnika a content[1] to informacja czy tekst jest edytowalny.

func _ready() -> void:
	# kod przypisujacy tekst do aplikacji
	$AppCode/ColorRect/TextEdit.text = content[0]
	if content[1] == true:

		$AppCode/ColorRect/TextEdit.editable=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
