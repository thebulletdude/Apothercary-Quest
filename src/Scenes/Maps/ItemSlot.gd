extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func get_drag_data(_position):
	var currentSlot = get_parent().get_name()
	#Ensures that there is an item in a slot before allowing to drag.
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
	
	
func can_drop_data(_position, data):
	var targetNode = get_parent().get_name()
	
	#Sets whether or not the hovered tile has an item or not.
	if(InventoryData.main_inventory[targetNode] == null):
		data["target_item_id"] = null
		data["target_texture"] = null
	else:
		data["target_item_id"] = InventoryData.main_inventory[targetNode]
		data["target_texture"] = texture
	return true

func drop_data(_position, data):
	var targetNode = get_parent().get_name()
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
		
