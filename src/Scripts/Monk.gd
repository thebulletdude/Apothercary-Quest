extends Node2D

var player = false
var finishedQuest = false


func _process(_delta):
	if(player && Input.is_key_pressed(KEY_E) && !checkForItem(9) && !finishedQuest):
		Controller.currentQuest = 3
		Controller.message = "I need a fire potion so I can launch myself into the sky. I will trade it for these 3 ice potions"
		Controller.inDialogue = true
	elif(player && Input.is_key_pressed(KEY_E) && checkForItem(9) && !finishedQuest):
		Controller.currentQuest = 3
		Controller.inDialogue = true
		Controller.message = "I see you have a fire potion. I would like to trade it for 3 ice potions. Will you trade for it?"
		Controller.decision = true
	elif(player && Input.is_key_pressed(KEY_E) && finishedQuest):
		Controller.currentQuest = 3
		Controller.inDialogue = true
		Controller.message = "Thanks again for the potion"
	
	if(Controller.quests[3] == 1 && !finishedQuest):
		finishedQuest =  true
		Controller.acceptReward = null
		Controller.addItem(6)
		Controller.addItem(6)
		Controller.addItem(6)
		Controller.removeItem(9)
		
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
