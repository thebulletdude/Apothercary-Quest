extends Node2D

signal goforth

func _on_Button_pressed():
	emit_signal("goforth")
