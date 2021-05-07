extends Node

onready var current_scene = $Testing_Map
const combat_map = preload("res://src/Scenes/Maps/Combat_Map.tscn")
onready var outsideHome = $Testing_Map
onready var woods = preload("res://src/Scenes/Maps/Woods.tscn").instance()
onready var home = preload("res://src/Scenes/MapAssets/Home.tscn").instance()
onready var tavern = preload("res://src/Scenes/MapAssets/Tavern.tscn").instance()
onready var plains = preload("res://src/Scenes/Maps/Plains.tscn").instance()
var combat

const inventory_map = preload("res://src/Scenes/Maps/Inventory.tscn")
var inventory

func _process(_delta):
	if(Controller.combat == true):
		enter_battle()
	if(Controller.inventory == true):
		Controller.inventory = false
		open_Inventory()
	if(Controller.mapTrigger == true):
		mapChange()

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
	

#A function to switch the scene to the combat screen
func enter_battle():
	Controller.combat = false
	remove_child(current_scene)
	combat = combat_map.instance()
	#Adds the combat screen and makes sure that the proper methods are connected
	add_child(combat)
	combat.connect("combat_over", self, "_on_Combat_Map_combat_over")

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
	
