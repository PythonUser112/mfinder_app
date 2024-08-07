extends VBoxContainer

signal search

func _on_Button_pressed():
	emit_signal("search", $LineEdit.text)


func _input(_event):
	if Input.is_action_just_pressed("enter"):
		emit_signal("search", $LineEdit.text)
