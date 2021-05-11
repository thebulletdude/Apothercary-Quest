extends KinematicBody2D

const MAX_SPEED = 100
const FRICTION = 900
const ACCEL = 200
var combat = false

var velocity = Vector2.ZERO

enum direction {
	FRONT,
	BACK,
	LEFT,
	RIGHT
}
var currentDirection = direction.RIGHT


func _process(_delta):
	Controller.setPlayerPosition(position.x, position.y)
	combat = Controller.holdPlayer
	
	if Input.is_key_pressed(KEY_I):
		Controller.inventory = true

func _physics_process(delta):
	#combat = Global.combat
	if(!combat && !Controller.inDialogue):
		var inputVector = Vector2.ZERO
		#Gets the input and keeps all lengths the same
		inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		inputVector = inputVector.normalized()
		
		
		#Determines the direction and speed of the object
		if (inputVector != Vector2.ZERO):
			velocity = velocity.move_toward(inputVector * MAX_SPEED, delta * ACCEL)
			if(inputVector.y < 0):
				$PlayerSprite.animation = "RunB"
				currentDirection = direction.BACK
			elif(inputVector.y > 0):
				$PlayerSprite.animation = "RunF"
				currentDirection = direction.FRONT
			elif(inputVector.x > 0):
				$PlayerSprite.animation = "RunR"
				currentDirection = direction.RIGHT
			elif(inputVector.x < 0):
				$PlayerSprite.animation = "RunL"
				currentDirection = direction.LEFT
		else:
			if(currentDirection == direction.FRONT):
				$PlayerSprite.animation = "IdleF"
			elif(currentDirection == direction.BACK):
				$PlayerSprite.animation = "IdleB"
			elif(currentDirection == direction.RIGHT):
				$PlayerSprite.animation = "IdleR"
			else:
				$PlayerSprite.animation = "IdleL"
			velocity = velocity.move_toward(Vector2.ZERO, delta * FRICTION)\
		
		
		velocity = move_and_slide(velocity)
		
		
	else:
		$PlayerSprite.animation = "IdleR"

