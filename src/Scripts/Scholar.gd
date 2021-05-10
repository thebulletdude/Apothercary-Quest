extends Node2D

var player = false
var finishedQuest = false


func _process(_delta):
	if(player && Input.is_key_pressed(KEY_E) && !checkForItem(6) && !finishedQuest):
		Controller.currentQuest = 1
		Controller.message = "Hello I am a scientist from a land far far away. Can you help me aquire an Ice potion so that I may study the tundra."
		Controller.inDialogue = true
	elif(player && Input.is_key_pressed(KEY_E) && checkForItem(6) && !finishedQuest):
		Controller.currentQuest = 1
		Controller.inDialogue = true
		Controller.message = "I see you have an ice potion. I would like to trade it for 5 fire potions. Will you trade for it?"
		Controller.decision = true
	elif(player && Input.is_key_pressed(KEY_E) && finishedQuest):
		Controller.currentQuest = 1
		Controller.inDialogue = true
		Controller.message = "Thanks again for the potion"
	
	if(Controller.quests[1] == 1 && !finishedQuest):
		finishedQuest =  true
		Controller.acceptReward = null
		Controller.addItem(9)
		Controller.addItem(9)
		Controller.addItem(9)
		Controller.addItem(9)
		Controller.addItem(9)
		Controller.removeItem(6)
		
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
