extends Node2D

signal combat_over

#Enemy Variables
var enemyCount
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

#States
enum states {PLAYER, ENEMY, COMBAT_OVER}
var currentState

#Pointer
const pointer_Scene = preload("res://src/Scenes/Maps/Pointer.tscn")
var pointer



func _ready():
	spawnLocations = [$Enemy1, $Enemy2, $Enemy3, $Enemy4, $Enemy5, $Enemy6]
	healthTags = [$Enemy1/EnemyLabel1, $Enemy2/EnemyLabel2, $Enemy3/EnemyLabel3,
				  $Enemy4/EnemyLabel4, $Enemy5/EnemyLabel5, $Enemy6/EnemyLabel6]
	currentState = states.PLAYER
	$UI/HPLabel.text = "HP: " + str(Controller.HP)
	taken = [false, false, false, false, false, false]
	selected = spawnLocations[selectedIndex]
	enemyCount = Controller.enemyCount
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

func _input(ev):
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
	
	
	if(currentState == states.PLAYER):
		$UI.visible = true
		pass
	elif(currentState == states.ENEMY):
		$UI.visible = false
		#Enemy AI
		for n in enemyCount:
			print("ENEMY " + str(n) + " ATTACKS")
			hit = randi()%99+10
			print("A " + str(hit) + "% chance  to hit") 
			if(hit < 50):
				print("ENEMY " + str(n) + " MISSES")
			else:
				print("ENEMY " + str(n) + " HITS")
				Controller.HP -= 1
				$UI/HPLabel.text = "HP: " + str(Controller.HP)
		if(Controller.HP <= 0):
			#TODO create death screen
			currentState = states.COMBAT_OVER
		else:
			currentState = states.PLAYER
	elif(currentState == states.COMBAT_OVER):
		#TODO create victory screen
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
	pass # Replace with function body.


func _on_FleeButton_pressed():
	emit_signal("combat_over")
