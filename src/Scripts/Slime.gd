extends KinematicBody2D

var default = Vector2(0, 0)
var MAX_SPEED = 200
var ACCEL  = 100
var TRIGGERED = false

var target = Vector2(0,0)
var velocity = Vector2(0, 0)

func _physics_process(_delta):
	if(TRIGGERED == true):
		var PlayerNode = Vector2(Controller.playerX, Controller.playerY)
		velocity = position.direction_to(PlayerNode) * ACCEL
		# look_at(target)
		if position.distance_to(PlayerNode) > 5:
			velocity = move_and_slide(velocity)

func _on_DetectionCircle_body_entered(body):
	if(body.get_name() == "Player"):
		TRIGGERED = true


func _on_CombatCircle_body_entered(body):
	if(body.get_name() == "Player"):
		Controller.updateCombat(true, null)
		queue_free()
