extends KinematicBody2D
#Variables to adjust speed
var default = Vector2(0, 0)
var MAX_SPEED = 200
var ACCEL  = 100

var TRIGGERED = false
var target = Vector2(0,0)
var velocity = Vector2(0, 0)

#Combat Variables
const maxEnemies = 4
const minHP = 1
const maxHP = 8
const actor = "res://src/Scenes/Monsters/Actors/act_BallBoy.tscn"
const actorScene = "act_BallBoy"

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
