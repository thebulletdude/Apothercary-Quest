extends YSort

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Controller.final):
		$StaticBody2D3/WoodsBoundary.disabled = true


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


func _on_Area2D4_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint5.position.x
		$Player.position.y = $SpawnPoint5.position.y
		Controller.nextMap = Controller.areas.SNOW
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true


func _on_Area2D5_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint6.position.x
		$Player.position.y = $SpawnPoint6.position.y
		Controller.nextMap = Controller.areas.MFOREST
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true
