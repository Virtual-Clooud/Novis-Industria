extends Spatial

func _on_area_entered(area):
	print("skoot")
	if(area.is_in_group("traveler")):
		get_tree().change_scene("res://scenes/cave.tscn")
#	if area that entered is_in_group(traveler) then change scene to cave
