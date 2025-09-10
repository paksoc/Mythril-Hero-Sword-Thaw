extends TouchScreenButton

class_name TouchButton

@export var focus:bool=false


func _ready() -> void:
	pass # Replace with function body.

func get_neighbors()-> Array:
	var siblings = get_parent().get_children()
	var result := []
	
	for sibling in siblings:
		if sibling.is_class("TouchScreenButton"):
			result.append(sibling)
	
	return result


func _process(delta: float) -> void:
	pass
	
