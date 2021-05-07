extends Node

#Player variables
var playerX
var playerY
var HP = 10
var mHP = 10
var holdPlayer = false
var playerEXP

var enemyDamage = 0

enum areas{
	WOODS,
	HOME,
	PLAINS,
	OUTSIDEHOME,
	TAVERN
}

#Glboal Variables
var random = RandomNumberGenerator.new()
var inventory = false
var mapTrigger = false
var nextMap = areas.OUTSIDEHOME
var currentMap = areas.WOODS


#Combat Variables
var enemyEncountering = []
var enemyCount
var combat = false
var enemyActor
var currentEnemy
var minHP
var maxHP
var actorReference

#Sets the global player position so that the enemy can find the player
func setPlayerPosition(x, y):
	playerX = x
	playerY = y

func enemySetup(enemy):
	currentEnemy = enemy.monsterName
	minHP = enemy.minHP
	maxHP = enemy.maxHP
	enemyActor = enemy.actor
	actorReference = enemy.actorScene
	var maxEnemies = enemy.maxEnemies
	randomize()
	enemyCount = randi()%maxEnemies+1
	for _n in range(0, enemyCount):
		randomize()
		var randomHP = randi()%maxHP+minHP
		enemyEncountering.append(randomHP)

func updateCombat(x, enemy):
	combat =  x
	holdPlayer = x
	enemySetup(enemy)
	
func addItem(x):
	for n in InventoryData.main_inventory:
		if(InventoryData.main_inventory[n] == null):
			InventoryData.main_inventory[n] = x
			return 1
	
