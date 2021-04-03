extends Node2D

signal combat_over

func _on_AttackButton_pressed():
	emit_signal("combat_over")
