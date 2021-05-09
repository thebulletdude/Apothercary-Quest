extends Node2D

var SpawnPoints

var enemy = [null, null, null, null]
var canSpawn = [true, true, true, true]
var timers 

func _ready():
	SpawnPoints = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4]
	timers = [$Timer1, $Timer2, $Timer3, $Timer4]
func _process(_delta):
	spawnEnemies()
	var count = 0
	for n in enemy:
		if(is_instance_valid(n)):
			timers[count].start(5)
		count += 1
	print(enemy)
		
func spawnEnemies():
	var count = 0
	for n in enemy:
		if(n == null && canSpawn[count]):
			var temp = load("res://src/Scenes/Monsters/OpenWorld/Snowman.tscn").instance()
			temp.position.x = SpawnPoints[count].position.x
			temp.position.y = SpawnPoints[count].position.y
			n = temp
			enemy[count] = temp
			add_child(temp)
			canSpawn[count] = false
		count += 1


func _on_Timer1_timeout():
	print("ring")
	canSpawn[0] = true

func _on_Timer2_timeout():
	print("ring")
	canSpawn[1] = true

func _on_Timer3_timeout():
	print("ring")
	canSpawn[2] = true

func _on_Timer4_timeout():
	print("ring")
	canSpawn[3] = true


func _on_Exit_body_entered(body):
	if(body.get_name() == "Player"):
		$Player.position.x = $SpawnPoint.position.x
		$Player.position.y = $SpawnPoint.position.y
		Controller.nextMap = Controller.areas.OUTSIDEHOME
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true
