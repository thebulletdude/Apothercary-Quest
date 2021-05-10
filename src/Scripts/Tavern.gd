extends Node2D

var final = false

func _process(_delta):
	if(Controller.inDialogue):
		if(Controller.decision):
			$DialogueScreen/YesButton.visible = true
			$DialogueScreen/NoButton.visible = true
		else:
			$DialogueScreen/YesButton.visible = false
			$DialogueScreen/NoButton.visible = false
		$DialogueScreen/DialogueLabel.text = Controller.message
		$DialogueScreen.visible = true
	if(calcQuest() == 4 && !final):
		$Position2D.add_child(load("res://src/Scenes/Player/King.tscn").instance())
		final = true
	

func calcQuest():
	var total = 0
	for n in Controller.quests:
		total += n
	return total


func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint.position.x
		$Player.position.y = $SpawnPoint.position.y
		Controller.nextMap = Controller.areas.OUTSIDEHOME
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true

func _on_YesButton_pressed():
	$DialogueScreen/DialogueLabel.text = "Thank you very much"
	$DialogueScreen/YesButton.visible = false
	$DialogueScreen/NoButton.visible = false
	Controller.quests[Controller.currentQuest] = 1
	Controller.acceptReward = true
	Controller.decision = false


func _on_NoButton_pressed():
	$DialogueScreen/DialogueLabel.text = "If you change your mind I will be here."
	$DialogueScreen/YesButton.visible = false
	$DialogueScreen/NoButton.visible = false
	Controller.acceptReward = null
	Controller.decision = false


func _on_Done_pressed():
	Controller.inDialogue = false
	$DialogueScreen.visible = false

