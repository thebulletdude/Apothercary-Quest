extends Node

var invData


var main_inventory = {
	"Slot1": null,
	"Slot2": 2,
	"Slot3": 5,
	"Slot4": null,
	"Slot5": 7,
	"Slot6": 8,
	"Slot7": 13,
	"Slot8": 16,
	"Slot9": 14,
	"Slot10": 15,
	"Slot11": 17,
	"Slot12": null,
	"Slot13": null,
	"Slot14": null,
	"Slot15": null,
	"Slot16": null,
	"Slot17": null,
	"Slot18": null,
	"Slot19": null,
	"Slot20": null,
	"Slot21": null,
	"Slot22": null,
	"Slot23": null,
	"Slot24": null,
	"Slot25": null,
	"Slot26": null,
	"Slot27": null,
	"Slot28": null,
	"Slot29": null,
	"Slot30": null,
	"Slot31": null,
	"Slot32": null,
	"Slot33": null,
	"Slot34": null,
	"Slot35": null,
	"Slot36": null}

#These are the slots for the crafting menu.
#Slot 4 is dedicated to the final product
var crafting_slots = {
	"Craft1": null,
	"Craft2": null,
	"Craft3": null,
	"Craft4": null
}

var recipes = {
	"Healing Potion": [2, 5, 7],
	"Fire Potion": [8, 13, 16],
	"Ice Potion": [14, 15, 17]
}
var product = {
	"Healing Potion": 4,
	"Fire Potion": 9,
	"Ice Potion": 6
}



# Called when the node enters the scene tree for the first time.
func _ready():
	var inv_data_file = File.new()
	inv_data_file.open("res://Data/AQItems.json", File.READ)
	var inv_data_json = JSON.parse(inv_data_file.get_as_text())
	inv_data_file.close()
	invData = inv_data_json.result


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
