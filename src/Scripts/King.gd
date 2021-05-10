extends Node2D

var player = false
var finishedQuest = false


func _process(_delta):
	if(player && Input.is_key_pressed(KEY_E)):
		Controller.currentQuest = 3
		Controller.message = "It is I, your great king. I have a very important task for you alchemist. You must go to the woods to the west and defeat the ancient danger which lies there. I recomend that you prepare for what lies ahead."
		Controller.inDialogue = true
		Controller.final = true
		
func _on_InteractionBubble_body_entered(body):
	if(body.get_name() == "Player"):
		player = true
	

func _on_InteractionBubble_body_exited(body):
	if(body.get_name() == "Player"):
		player = false

#Checks to see if the player has the item for the quest
func checkForItem(x):
	for n in InventoryData.main_inventory:
		if(InventoryData.main_inventory[n] == x):
			return true
	return false
