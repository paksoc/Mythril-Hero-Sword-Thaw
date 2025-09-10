extends Resource

class_name Condition

@export var comparison_method: String
var __cached_node: Node

func is_met(subject: Node) -> bool:
	init_and_cache(subject)
	if !__cached_node:  # Safety check in case init_and_cache failed
		return false
	return __cached_node.call(comparison_method) as bool

func init_and_cache(_subject: Node):
	if __cached_node:
		return
	
	if !_subject:
		push_error("Err @ %s> The condition does not have a subject."
			 % [resource_path])
		return
	
	if !_subject.has_method(comparison_method):
		push_error('Err @ %s> %s method not found in %s.'
		 % [resource_path, comparison_method, _subject.name])
		return
	
	if !(typeof(_subject.call(comparison_method)) == TYPE_BOOL):
		push_error("Err @ %s> method %s is not of type bool"
		 % [resource_path, comparison_method])
		return
	
	__cached_node = _subject
	return
