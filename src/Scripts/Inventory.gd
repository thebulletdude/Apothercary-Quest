extends Node2D

signal closing


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var i1
var i2
var i3
var i4

var recipe
var currentItem
var itemName

var check = [null, null, null]




# Called when the node enters the scene tree for the first time.
func _ready():
	#So that the inventory remembers where you put stuff.
	for n in InventoryData.main_inventory:
		if(InventoryData.main_inventory[n] != null):
			var item = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData[str(InventoryData.main_inventory[n])]["ItemName"] + ".png"))
			var tag = "NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/ColorRect/InventoryContainer/" + n + "/Icon/"
			get_node(tag).texture = item
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for n in range(0, 3):
		if(InventoryData.crafting_slots["Craft" + str(n + 1)] != null):
			check[n] = InventoryData.crafting_slots["Craft" + str(n + 1)]
		else:
			check[n] = null
	if(isRecipe()):
		$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect/VBoxContainer/CreateButton.disabled = false
	else:
		$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect/VBoxContainer/CreateButton.disabled = true
	
	

func checkArrays(n):
	currentItem = n
	var index = 0
	var count = 0
	var currentRecipe = InventoryData.recipes[n]
	for n in currentRecipe:
		if(n == check[index]):
			count += 1
		index += 1
	if(count == 3):
		return true
	return false



func isRecipe():
	for n in InventoryData.recipes:
		if(checkArrays(n)):
			itemName = n
			recipe = InventoryData.recipes[n]
			return true
	return false

func _on_DoneButton_pressed():
	Controller.inventory = false
	emit_signal("closing")

#################################################################
#################################################################
#################################################################
#################################################################
#Potions
#This section will contain all of the potion recipies
#Upon clicking the desired recipie the inventory will present what the item should be
#################################################################
#################################################################

func setRecipe():
	$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect2/VBoxContainer/GridContainer2/Recipe1/Icon.texture = i1
	$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect2/VBoxContainer/GridContainer2/Recipe2/Icon.texture = i2
	$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect2/VBoxContainer/GridContainer2/Recipe3/Icon.texture = i3
	$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect2/VBoxContainer/GridContainer2/Recipe4/Icon.texture = i4
func _on_Minor_Healing_Potion_pressed():
	i1 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["2"]["ItemName"] + ".png"))
	i2 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["5"]["ItemName"] + ".png"))
	i3 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["7"]["ItemName"] + ".png"))
	i4 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["4"]["ItemName"] + ".png"))
	setRecipe()


func _on_CreateButton_pressed():
	for n in range(1, 4):
		var tag = "Craft" + str(n)
		var line = "NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect/VBoxContainer/GridContainer/" + tag + "/Icon/"
		InventoryData.crafting_slots[tag] = null
		get_node(line).texture = null
	InventoryData.crafting_slots["Craft4"] = InventoryData.product[currentItem]
	$NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ColorRect/VBoxContainer/GridContainer/Craft4/Icon.texture = load("res://src/Assets/Inventory/Items/" + currentItem + ".png")
	


func _on_Fire_Potion_pressed():
	i1 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["8"]["ItemName"] + ".png"))
	i2 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["13"]["ItemName"] + ".png"))
	i3 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["16"]["ItemName"] + ".png"))
	i4 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["9"]["ItemName"] + ".png"))
	setRecipe()


func _on_Ice_Potion_pressed():
	i1 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["14"]["ItemName"] + ".png"))
	i2 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["15"]["ItemName"] + ".png"))
	i3 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["17"]["ItemName"] + ".png"))
	i4 = load("res://src/Assets/Inventory/Items/" + str(InventoryData.invData["6"]["ItemName"] + ".png"))
	setRecipe()
