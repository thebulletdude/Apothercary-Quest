extends Node

#Player variables
var playerX
var playerY
var HP

#Glboal Variables
var combat = false
var enemyEncountering

#Sets the global player position so that the enemy can find the player
func setPlayerPosition(x, y):
	playerX = x
	playerY = y

func updateCombat(x, _enemy):
	combat =  x
	enemyEncountering =  _enemy
