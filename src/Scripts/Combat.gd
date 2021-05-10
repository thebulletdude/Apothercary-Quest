extends Node2D

signal combat_over
signal gameOver

#Enemy Variables
var enemyCount
var originalEnemyCount
var enemyList
var enemy
var actor
var actorReference
var hit
var enemies = []

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


var attacked = false
var attacking = false


#States
enum states {PLAYER, ENEMY, COMBAT_OVER}
var currentState

#Pointer
const pointer_Scene = preload("res://src/Scenes/Maps/Pointer.tscn")
var pointer
var finalBattle = false


func _ready():
	if(Controller.finalBattle == true):
		finalBattle = true
		
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
	invContainsPotions()
	
	#Setup The Fight
	for n in enemyCount:
		enemies.append(actor.instance())
		spawnLocations[n].add_child(enemies[n])
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
		if(!attacking):
			$UI.visible = true
			pointer.visible = true
	elif(currentState == states.ENEMY):
		$UI.visible = false
		pointer.visible = false
		#Enemy AI
		if(!attacked):
			fight()
	elif(currentState == states.COMBAT_OVER):
		Controller.enemyEncountering = []
		Controller.combat = false
		$Pointer.visible = false
		$ItemList.visible = false
		$UI.visible = false
		$EndPanel.visible = true
		if(Controller.HP <= 0):
			$EndPanel/VBoxContainer/HBoxContainer/Panel/DefeatLabel.visible = true
		elif(finalBattle):
			emit_signal("gameOver")
		else:
			$EndPanel/VBoxContainer/HBoxContainer/Panel/VictoryLabel.visible = true
		if(Input.is_key_pressed(KEY_E)):
			emit_signal("combat_over")

func _on_AttackButton_pressed():
	attacking = true
	enemyList[selectedIndex] -= 1
	healthTags[selectedIndex].text = str(enemyList[selectedIndex])
	#This code runs if an enemy is dead Reseting some of the values
	$UI.visible = false
	$ItemList.visible = false
	if(enemyList[selectedIndex] <= 0):
		enemyCount -= 1
		enemies[selectedIndex] = null
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
	$Player/AnimationPlayer.play("attack")
	yield($Player/AnimationPlayer, "animation_finished")
	if(enemyCount > 0):
		attacking = false
		currentState = states.ENEMY
	else:
		attacking = false
		currentState = states.COMBAT_OVER


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
	$UI.visible = false
	for n in range(len(enemyList)):
		if(_checkAvailable(n)):
			enemyList[n] -= 5
			healthTags[n].text = str(enemyList[n])
	AoECheck()
	removePotion(findPotionIndex(9))
	
func _on_IcePotion_pressed():
	$UI.visible = false
	for n in range(len(enemyList)):
		if(_checkAvailable(n)):
			enemyList[n] -= 5
			healthTags[n].text = str(enemyList[n])
	AoECheck()
	removePotion(findPotionIndex(6))
	
func _on_HealthPotion_pressed():
	$UI.visible = false
	Controller.HP += 5
	if(Controller.HP > Controller.mHP):
		Controller.HP = Controller.mHP
	$UI/HPLabel.text = "HP: " + str(Controller.HP)
	removePotion(findPotionIndex(4))
	$ItemList.visible = false
	if(enemyCount > 0):
		currentState = states.ENEMY
	else:
		currentState = states.COMBAT_OVER
	
func AoECheck():
	var count = 0
	for n in enemyList:
		if(n <= 0 && taken[count]):
			enemyCount -= 1
			enemies[count] == null
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
	$ItemList.visible = false
	if(enemyCount > 0):
		currentState = states.ENEMY
	else:
		currentState = states.COMBAT_OVER

func invContainsPotions():
	var containsPotion = false
	$ItemList/ScrollContainer/VBoxContainer/HealthPotion.visible = false
	$ItemList/ScrollContainer/VBoxContainer/FirePotion.visible = false
	$ItemList/ScrollContainer/VBoxContainer/IcePotion.visible = false
	for n in InventoryData.main_inventory:
		if(InventoryData.main_inventory[n] == 4):
			$ItemList/ScrollContainer/VBoxContainer/HealthPotion.visible = true
			containsPotion = true
		elif(InventoryData.main_inventory[n] == 9):
			$ItemList/ScrollContainer/VBoxContainer/FirePotion.visible = true
			containsPotion = true
		elif(InventoryData.main_inventory[n] == 6):
			$ItemList/ScrollContainer/VBoxContainer/IcePotion.visible = true
			containsPotion = true
	if(!containsPotion):
		$ItemList/ScrollContainer/VBoxContainer/NoPotionLabel.visible = true
	else:
		$ItemList/ScrollContainer/VBoxContainer/NoPotionLabel.visible = false
		
func findPotionIndex(x):
	for n in InventoryData.main_inventory:
		if(InventoryData.main_inventory[n] == x):
			return n

func removePotion(x):
	InventoryData.main_inventory[x] = null

func fight():
	attacked = true
	var count = 0
	for n in taken:
		if(n):
			var currentEnemy = load("res://src/Scenes/Monsters/OpenWorld/" + enemy + ".tscn").instance()
			hit = currentEnemy.fight()
			$InformationPanel.visible = true
			if(hit):
				$InformationPanel/DamageLabel.text = "The enemy hits dealing " + str(Controller.enemyDamage) + " damage."
				Controller.HP -= Controller.enemyDamage
				$UI/HPLabel.text = "HP: " + str(Controller.HP)
			else:
				$InformationPanel/DamageLabel.text = "The enemy misses."
			enemies[count].get_node("AnimationPlayer").play("attack")
			yield(enemies[count].get_node("AnimationPlayer"), "animation_finished")
		count += 1
	invContainsPotions()
	$InformationPanel.visible = false
	if(Controller.HP <= 0):
		currentState = states.COMBAT_OVER
		attacked = false
	else:
		currentState = states.PLAYER
		attacked = false
