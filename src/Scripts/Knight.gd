extends Node2D

var player = false
var finishedQuest = false


func _process(_delta):
	if(player && Input.is_key_pressed(KEY_E) && !checkForItem(4) && !finishedQuest):
		Controller.currentQuest = 0
		Controller.message = "Hello kind sir. May you obtain me a health potion for I have fallen ill. I can reward you with this Ice potion as a reward"
		Controller.inDialogue = true
	elif(player && Input.is_key_pressed(KEY_E) && checkForItem(4) && !finishedQuest):
		Controller.currentQuest = 0
		Controller.inDialogue = true
		Controller.message = "I see you have a health potion. I would like to take it in exchange for an Ice Potion. Will you trade it?"
		Controller.decision = true
	elif(player && Input.is_key_pressed(KEY_E) && finishedQuest):
		Controller.currentQuest = 0
		Controller.inDialogue = true
		Controller.message = "Thanks again for the potion"
	
	if(Controller.quests[0] == 1 && !finishedQuest):
		finishedQuest =  true
		Controller.acceptReward = null
		Controller.addItem(6)
		Controller.removeItem(4)
		
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
