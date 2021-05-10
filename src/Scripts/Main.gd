extends Node

onready var main_menu = $HomeScreen
const combat_map = preload("res://src/Scenes/Maps/Combat_Map.tscn")
onready var outsideHome = preload("res://src/Scenes/Maps/Testing_Map.tscn").instance()
onready var woods = preload("res://src/Scenes/Maps/Woods.tscn").instance()
onready var home = preload("res://src/Scenes/MapAssets/Home.tscn").instance()
onready var tavern = preload("res://src/Scenes/MapAssets/Tavern.tscn").instance()
onready var plains = preload("res://src/Scenes/Maps/Plains.tscn").instance()
onready var snow = preload("res://src/Scenes/Maps/SnowArea.tscn").instance()
onready var mforest = preload("res://src/Scenes/Maps/MiniForest.tscn").instance()
onready var controls = preload("res://src/Scenes/Maps/Controls.tscn").instance()
onready var credits = preload("res://src/Scenes/Maps/Credits.tscn").instance()
onready var current_scene = home
var combat

const inventory_map = preload("res://src/Scenes/Maps/Inventory.tscn")
var inventory


func _ready():
	credits.connect("done", self, "end_credits")
	controls.connect("goforth", self, "on_GoForth")
func _process(_delta):
	if(Controller.start):
		Controller.start = false
		remove_child(main_menu)
		add_child(controls)
		Controller.currentMap = Controller.areas.HOME
	if(Controller.credits):
		Controller.credits = false
		remove_child(main_menu)
		add_child(credits)
	if(Controller.combat == true):
		enter_battle()
	if(Controller.inventory == true):
		if(!combat):
			open_Inventory()
		Controller.inventory = false
	if(Controller.mapTrigger == true):
		mapChange()

func end_credits():
	remove_child(credits)
	get_tree().reload_current_scene()

func mapChange():
	Controller.mapTrigger = false
	if(Controller.nextMap == Controller.areas.WOODS):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = woods
		add_child(current_scene)
		Controller.currentMap = Controller.areas.WOODS
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.WOODS):
		woods = current_scene
		remove_child(woods)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap = Controller.areas.OUTSIDEHOME
	elif(Controller.nextMap == Controller.areas.HOME):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = home
		add_child(current_scene)
		Controller.currentMap = Controller.areas.HOME
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.HOME):
		home = current_scene
		remove_child(home)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap =  Controller.areas.OUTSIDEHOME
	elif(Controller.nextMap == Controller.areas.TAVERN):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = tavern
		add_child(current_scene)
		Controller.currentMap = Controller.areas.TAVERN
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.TAVERN):
		tavern = current_scene
		remove_child(tavern)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap =  Controller.areas.OUTSIDEHOME
	elif(Controller.nextMap == Controller.areas.PLAINS):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = plains
		add_child(current_scene)
		Controller.currentMap = Controller.areas.PLAINS
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.PLAINS):
		plains = current_scene
		remove_child(plains)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap = Controller.areas.OUTSIDEHOME
	elif(Controller.nextMap == Controller.areas.SNOW):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = snow
		add_child(current_scene)
		Controller.currentMap = Controller.areas.SNOW
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.SNOW):
		snow = current_scene
		remove_child(snow)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap = Controller.areas.OUTSIDEHOME
	elif(Controller.nextMap == Controller.areas.MFOREST):
		outsideHome = current_scene
		remove_child(outsideHome)
		current_scene = mforest
		add_child(current_scene)
		Controller.currentMap = Controller.areas.MFOREST
	elif(Controller.nextMap == Controller.areas.OUTSIDEHOME && Controller.currentMap == Controller.areas.MFOREST):
		mforest = current_scene
		remove_child(mforest)
		current_scene = outsideHome
		add_child(current_scene)
		Controller.currentMap = Controller.areas.OUTSIDEHOME

#A function to switch the scene to the combat screen
func enter_battle():
	Controller.combat = false
	remove_child(current_scene)
	combat = combat_map.instance()
	#Adds the combat screen and makes sure that the proper methods are connected
	add_child(combat)
	combat.connect("combat_over", self, "_on_Combat_Map_combat_over")
	combat.connect("gameOver", self, "_on_gameOver")
	
func _on_gameOver():
	combat.queue_free()
	add_child(credits)
	
	
func on_GoForth():
	remove_child(controls)
	add_child(current_scene)

#Gets called after combat returns to the original position. Resets the combat.
func exit_battle():
	Controller.holdPlayer = false
	combat.queue_free()
	add_child(current_scene)

func _on_Controller_combat():
	enter_battle()

func _on_Combat_Map_combat_over():
	exit_battle()
	
func open_Inventory():
	remove_child(current_scene)
	inventory = inventory_map.instance()
	add_child(inventory)
	inventory.connect("closing", self, "_on_Inventory_closing")
	
func _on_Inventory_closing():
	inventory.queue_free()
	add_child(current_scene)
	
