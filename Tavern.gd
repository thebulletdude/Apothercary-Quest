extends Node2D

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint.position.x
		$Player.position.y = $SpawnPoint.position.y
		Controller.nextMap = Controller.areas.OUTSIDEHOME
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true
