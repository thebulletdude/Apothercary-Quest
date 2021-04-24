extends Node

onready var current_scene = $Testing_Map
const combat_map = preload("res://src/Scenes/Maps/Combat_Map.tscn")
var combat

const inventory_map = preload("res://src/Scenes/Maps/Inventory.tscn")
var inventory

func _process(_delta):
	if(Controller.combat == true):
		enter_battle()
	if(Controller.inventory == true):
		Controller.inventory = false
		open_Inventory()

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
	
