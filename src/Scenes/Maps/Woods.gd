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
		$Player.position.x = $SpawnPoint.position.x
		$Player.position.y = $SpawnPoint.position.y
		Controller.nextMap = Controller.areas.OUTSIDEHOME
		$Player.velocity = Vector2.ZERO
		Controller.mapTrigger = true
