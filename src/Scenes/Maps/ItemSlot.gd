extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func get_drag_data(_position):
	var currentSlot = get_parent().get_name()
	#Ensures that there is an item in a slot before allowing to drag.
	if "Slot" in currentSlot:
		if InventoryData.main_inventory[currentSlot] != null:
			var data = {}
			data["originNode"] = self
			data["originID"] = InventoryData.main_inventory[currentSlot]
			data["origin_texture"] = texture
			
			
			var drag_texture = TextureRect.new()
			drag_texture.expand = true
			drag_texture.texture = texture
			drag_texture.rect_size = Vector2(72,72)
			
			var control = Control.new()
			control.add_child(drag_texture)
			drag_texture.rect_position = -.5 * drag_texture.rect_size
			
			set_drag_preview(control)
			
			return data
	if "Craft" in currentSlot:
		if InventoryData.crafting_slots[currentSlot] != null:
			var data = {}
			data["originNode"] = self
			data["originID"] = InventoryData.crafting_slots[currentSlot]
			data["origin_texture"] = texture
			
			
			var drag_texture = TextureRect.new()
			drag_texture.expand = true
			drag_texture.texture = texture
			drag_texture.rect_size = Vector2(72,72)
			
			var control = Control.new()
			control.add_child(drag_texture)
			drag_texture.rect_position = -.5 * drag_texture.rect_size
			
			set_drag_preview(control)
			
			return data
	
	
func can_drop_data(_position, data):
	var targetNode = get_parent().get_name()
	
	if("Slot" in targetNode):
		#Sets whether or not the hovered tile has an item or not.
		if(InventoryData.main_inventory[targetNode] == null):
			data["target_item_id"] = null
			data["target_texture"] = null
		else:
			data["target_item_id"] = InventoryData.main_inventory[targetNode]
			data["target_texture"] = texture
		return true
	elif("Craft" in targetNode && targetNode != "Craft4"):
		if(InventoryData.crafting_slots[targetNode] == null):
			data["target_item_id"] = null
			data["target_texture"] = null
		else:
			data["target_item_id"] = InventoryData.crafting_slots[targetNode]
			data["target_texture"] = texture
		return true
	else:
		return false
		

func drop_data(_position, data):
	var targetNode = get_parent().get_name()
	if("Slot" in targetNode && "Slot" in data["originNode"].get_parent().get_name()):
		if(data["target_item_id"] == null):
			#If there is no item. Place the item and delete the old
			InventoryData.main_inventory[targetNode] = data["originID"]
			texture = data["origin_texture"]
			data["originNode"].texture = null
			InventoryData.main_inventory[data["originNode"].get_parent().get_name()] = null
		else:
			#If there is an item in the target location. Then we need to swap
			data["originNode"].texture = texture
			texture = data["origin_texture"]
			InventoryData.main_inventory[data["originNode"].get_parent().get_name()] = InventoryData.main_inventory[targetNode]
			InventoryData.main_inventory[targetNode] = data["originID"]
	elif("Slot" in targetNode && "Craft" in data["originNode"].get_parent().get_name()):
		if(data["target_item_id"] == null):
			#If there is no item. Place the item and delete the old
			InventoryData.main_inventory[targetNode] = data["originID"]
			texture = data["origin_texture"]
			data["originNode"].texture = null
			InventoryData.crafting_slots[data["originNode"].get_parent().get_name()] = null
		else:
			#If there is an item in the target location. Then we need to swap
			data["originNode"].texture = texture
			texture = data["origin_texture"]
			InventoryData.crafting_slots[data["originNode"].get_parent().get_name()] = InventoryData.main_inventory[targetNode]
			InventoryData.main_inventory[targetNode] = data["originID"]
	#This codde represents the swap between the inventory and crafting menu
	elif("Craft" in targetNode && targetNode != "Craft4" && "Slot" in data["originNode"].get_parent().get_name()):
		if(data["target_item_id"] == null):
			#If there is no item. Place the item and delete the old
			InventoryData.crafting_slots[targetNode] = data["originID"]
			texture = data["origin_texture"]
			data["originNode"].texture = null
			InventoryData.main_inventory[data["originNode"].get_parent().get_name()] = null
		else:
			#If there is an item in the target location. Then we need to swap
			data["originNode"].texture = texture
			texture = data["origin_texture"]
			InventoryData.main_inventory[data["originNode"].get_parent().get_name()] = InventoryData.crafting_slots[targetNode]
			InventoryData.crafting_slots[targetNode] = data["originID"]
	#This is to swap between things in the crafting menu
	else:
		if(data["target_item_id"] == null):
			#If there is no item. Place the item and delete the old
			InventoryData.crafting_slots[targetNode] = data["originID"]
			texture = data["origin_texture"]
			data["originNode"].texture = null
			InventoryData.crafting_slots[data["originNode"].get_parent().get_name()] = null
		else:
			#If there is an item in the target location. Then we need to swap
			data["originNode"].texture = texture
			texture = data["origin_texture"]
			InventoryData.crafting_slots[data["originNode"].get_parent().get_name()] = InventoryData.crafting_slots[targetNode]
			InventoryData.crafting_slots[targetNode] = data["originID"]
	print("Crafting Slots\n" + str(InventoryData.crafting_slots) + "\n")
	print("Main Inventory\n" + str(InventoryData.main_inventory) + "\n")
