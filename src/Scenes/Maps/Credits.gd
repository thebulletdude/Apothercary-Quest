extends Node2D

signal done

func _on_Button_pressed():
	emit_signal("done")
