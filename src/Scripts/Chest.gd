extends Node2D

var player = false
var opened = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(_delta):
	if(player && Input.is_key_pressed(KEY_E)) && !opened:
		$ChestSprite.texture = load("res://src/Assets/Sprites/OpenedChest.png")
		var random = randi()%100 + 1
		if(random > 0 && random < 33):
			random = 4
		elif(random >=  33 && random < 66):
			random = 9
		else:
			random = 6
		Controller.addItem(random)



func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		player = true


func _on_Area2D_body_exited(body):
	if(body.get_name() == "Player"):
		player = false

