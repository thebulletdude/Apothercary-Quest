extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody2D_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint1.position.x
		$Player.position.y = $SpawnPoint1.position.y
		Controller.nextMap = Controller.areas.WOODS
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true


func _on_Area2D_body_exited(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint2.position.x
		$Player.position.y = $SpawnPoint2.position.y
		Controller.nextMap = Controller.areas.HOME
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true


func _on_Area2D2_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint3.position.x
		$Player.position.y = $SpawnPoint3.position.y
		Controller.nextMap = Controller.areas.TAVERN
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true


func _on_Area2D3_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint4.position.x
		$Player.position.y = $SpawnPoint4.position.y
		Controller.nextMap = Controller.areas.PLAINS
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true
