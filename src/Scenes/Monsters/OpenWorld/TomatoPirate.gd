extends KinematicBody2D

#Variables to adjust speed
var default = Vector2(0, 0)
var MAX_SPEED = 500
var ACCEL  = 150

var TRIGGERED = false
var target = Vector2(0,0)
var velocity = Vector2(0, 0)

#Combat Variables
const maxEnemies = 4
const monsterName = "TomatoPirate"
const minHP = 1
const maxHP = 2
const actor = "res://src/Scenes/Monsters/Actors/act_TomatoPirate.tscn"
const actorScene = "act_TomatoPirate"

#This is the movement of the enemy
func _physics_process(_delta):
	if(TRIGGERED == true):
		var PlayerNode = Vector2(Controller.playerX, Controller.playerY)
		velocity = position.direction_to(PlayerNode) * ACCEL
		# look_at(target)
		if position.distance_to(PlayerNode) > 5:
			velocity = move_and_slide(velocity)

#If the player enters the detection circle
#This will cause the enemy to chase.
func _on_DetectionCircle_body_entered(body):
	if(body.get_name() == "Player"):
		TRIGGERED = true


func _on_CombatCircle_body_entered(body):
	if(body.get_name() == "Player"):
		#To stop the player from sliding once reloading from combat
		body.velocity = Vector2.ZERO
		#Sends info to global to update the fight
		Controller.updateCombat(true, self)
		#Destroys the monster
		queue_free()
		
func fight():
	print("ENEMY ATTACKS")
	var hit = randi()%99+10
	var attackType = randi()%2
	if(attackType == 0):
		print("A " + str(hit) + "% chance  to hit") 
		if(hit < 75):
			print("ENEMY MISSES")
			return false
		else:
			print("ENEMY HITS")
			Controller.enemyDamage = 1
			return true
	if(attackType == 1):
		print("A " + str(hit) + "% chance  to hit") 
		if(hit < 5):
			print("ENEMY MISSES")
			return false
		else:
			print("ENEMY HITS")
			Controller.enemyDamage = 4
			return true
		
		
func drop():
	var drop = randi()%100 + 1
	if(drop >= 0 && drop < 33):
		return 8
	elif(drop >= 33 && drop < 66):
		return 13
	else:
		return 16
	
	
