extends Node



#Unsure whether back button works. Disabled for now.



var previous_screen: String = ""
var current_screen: String = ""

func _ready() -> void:
	Signals.change_screen.connect(_on_change_screen)
	
	pass

func _on_change_screen(old_screen: String, new_screen: String):
	var old_child = get_node_or_null(old_screen)
	var new_child = get_node_or_null(new_screen)
	
	if old_child and new_child:
		old_child.call("change_visibility", false)
		new_child.call("change_visibility", true)
		
		"""
		previous_screen = old_screen
		current_screen = new_screen
		print("current: ", current_screen, " | previous: ", previous_screen)
		if new_screen == "main_menu":
			$CanvasLayer.visible = false
		else:
			$CanvasLayer.visible = true
			
			pass
		"""
		
	else:
		print("no valid child found with the names: (old) ", old_screen, "and (new) ", new_screen)
		
		pass
		
	pass

func _on_back_pressed():
	_on_change_screen(current_screen, previous_screen)
	
	pass
