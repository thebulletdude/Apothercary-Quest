extends Node2D

signal combat_over

#Enemy Variables
var enemyCount
var originalEnemyCount
var enemyList
var enemy
var actor
var actorReference
var hit

#For the pointer as well as reference
var selected
var selectedIndex = 0

#Array to hold if an enemy is in a location or not.
var taken
var spawnLocations
var healthTags
var check = false
var finalItems
var itemsList = []
var setList = false


#States
enum states {PLAYER, ENEMY, COMBAT_OVER}
var currentState

#Pointer
const pointer_Scene = preload("res://src/Scenes/Maps/Pointer.tscn")
var pointer



func _ready():
	#Holds the spawn locations
	spawnLocations = [$Enemy1, $Enemy2, $Enemy3, $Enemy4, $Enemy5, $Enemy6]
	#Holds the health of each enemy for the player to see
	healthTags = [$Enemy1/EnemyLabel1, $Enemy2/EnemyLabel2, $Enemy3/EnemyLabel3,
				  $Enemy4/EnemyLabel4, $Enemy5/EnemyLabel5, $Enemy6/EnemyLabel6]
	#Array holds the slots for final items for the player to see
	finalItems = [$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems1,
				 $EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems2,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems3,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems4,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems5,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems6,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems7,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems8,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems9,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems10,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems11,
				$EndPanel/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer/FinalItems12,
				]
	currentState = states.PLAYER
	$UI/HPLabel.text = "HP: " + str(Controller.HP)
	taken = [false, false, false, false, false, false]
	selected = spawnLocations[selectedIndex]
	enemyCount = Controller.enemyCount
	originalEnemyCount = Controller.enemyCount
	enemyList = Controller.enemyEncountering
	actorReference = Controller.actorReference
	print(enemyList)
	enemy = Controller.currentEnemy
	actor = load(Controller.enemyActor)
	
	#Create  the first pointer
	pointer = pointer_Scene.instance()
	add_child(pointer)
	
	_move_Pointer()
	
	
	#Setup The Fight
	for n in enemyCount:
		spawnLocations[n].add_child(actor.instance())
		healthTags[n].text = str(enemyList[n])
		taken[n] = true

func _move_Pointer():
	selected = spawnLocations[selectedIndex]
	$Pointer.position.x = selected.position.x - 50
	$Pointer.position.y = selected.position.y
	
func _checkAvailable(x):
	if(taken[x]):
		return true
	else:
		return false

func _input(_ev):
	#These inputs are dedicated to the selector arrow
	if Input.is_key_pressed(KEY_RIGHT):
		while(!check):
			if(selectedIndex == 5):
				selectedIndex = 0
			else:
				selectedIndex += 1
			_move_Pointer()
			if(_checkAvailable(selectedIndex)):
				check = true
	if Input.is_key_pressed(KEY_LEFT):
		while(!check):
			if(selectedIndex == 0):
				selectedIndex = enemyCount - 1
			else:
				selectedIndex -= 1
			_move_Pointer()
			if(_checkAvailable(selectedIndex)):
				check = true
	check = false


func _process(_delta):
	if(enemyCount == 0):
		currentState = states.COMBAT_OVER
		var e = load("res://src/Scenes/Monsters/OpenWorld/" + enemy + ".tscn").instance()
		if(setList == false):
			for n in range(0, originalEnemyCount):
				var temp = e.drop()
				finalItems[n].texture = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData[str(temp)]["ItemName"] + ".png"))
				Controller.addItem(temp)
			setList = true
	if(currentState == states.PLAYER):
		$UI.visible = true
	elif(currentState == states.ENEMY):
		$UI.visible = false
		#Enemy AI
		for n in enemyCount:
			var currentEnemy = load("res://src/Scenes/Monsters/OpenWorld/" + enemy + ".tscn").instance()
			hit = currentEnemy.fight()
			if(hit):
				Controller.HP -= Controller.enemyDamage
				$UI/HPLabel.text = "HP: " + str(Controller.HP)
		if(Controller.HP <= 0):
			currentState = states.COMBAT_OVER
		else:
			currentState = states.PLAYER
	elif(currentState == states.COMBAT_OVER):
		Controller.enemyEncountering = []
		$Pointer.visible = false
		$ItemList.visible = false
		$UI.visible = false
		$EndPanel.visible = true
		if(Controller.HP <= 0):
			$EndPanel/VBoxContainer/HBoxContainer/Panel/DefeatLabel.visible = true
		else:
			$EndPanel/VBoxContainer/HBoxContainer/Panel/VictoryLabel.visible = true
		if(Input.is_key_pressed(KEY_E)):
			emit_signal("combat_over")

func _on_AttackButton_pressed():
	enemyList[selectedIndex] -= 1
	healthTags[selectedIndex].text = str(enemyList[selectedIndex])
	#This code runs if an enemy is dead Reseting some of the values
	if(enemyList[selectedIndex] <= 0):
		enemyCount -= 1
		selected.get_node(actorReference).queue_free()
		taken[selectedIndex] = false
		healthTags[selectedIndex].text = ""
		while(!check && enemyCount > 0):
			if(selectedIndex == 5):
				selectedIndex = 0
			else:
				selectedIndex += 1
			_move_Pointer()
			if(_checkAvailable(selectedIndex)):
				check = true
		check = false
	currentState = states.ENEMY


func _on_ItemButton_pressed():
	if($ItemList.visible):
		$ItemList.visible = false
	else:
		$ItemList.visible = true


func _on_FleeButton_pressed():
	emit_signal("combat_over")

############################
#POTIONS
###########################

func _on_FirePotion_pressed():
	for n in range(len(enemyList)):
		if(_checkAvailable(n)):
			enemyList[n] -= 5
			healthTags[n].text = str(enemyList[n])
	AoECheck()
	
func _on_IcePotion_pressed():
	for n in range(len(enemyList)):
		if(_checkAvailable(n)):
			enemyList[n] -= 5
			healthTags[n].text = str(enemyList[n])
	AoECheck()
	
func _on_HealthPotion_pressed():
	Controller.HP += 5
	if(Controller.HP > Controller.mHP):
		Controller.HP = Controller.mHP
	$UI/HPLabel.text = "HP: " + str(Controller.HP)
	
func AoECheck():
	var count = 0
	for n in enemyList:
		if(n <= 0 && taken[count]):
			enemyCount -= 1
			spawnLocations[count].get_node(actorReference).queue_free()
			taken[count] = false
			healthTags[count].text = ""
		count += 1
	while(!check && enemyCount > 0):
			if(selectedIndex == 5):
				selectedIndex = 0
			else:
				selectedIndex += 1
			_move_Pointer()
			if(_checkAvailable(selectedIndex)):
				check = true
	check = false
