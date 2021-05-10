extends KinematicBody2D

const MAX_SPEED = 200
const FRICTION = 900
const ACCEL = 200
var combat = false

var velocity = Vector2.ZERO


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
		else:
			velocity = velocity.move_toward(Vector2.ZERO, delta * FRICTION)
		
		
		velocity = move_and_slide(velocity)

