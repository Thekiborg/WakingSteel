extends Node

const PRIMITIVES:PackedInt64Array = [
	TYPE_BOOL,
	TYPE_FLOAT,
	TYPE_INT,
	TYPE_NIL,
	TYPE_STRING,
	TYPE_STRING_NAME,
]


func serialize(object: Object, field_info: PackedStringArray) -> Dictionary[String, Variant]:
	var result: Dictionary[String, Variant] = {}
	for field in field_info:
		result[field] = _serialize(object.get(field))
	return result


func _serialize(variant: Variant) -> Variant:
	var type: int = typeof(variant)
	if PRIMITIVES.has(type):
		return variant
	if variant is Texture2D:
		var img = variant as Texture2D
		return img.resource_path
	
	match type:
		TYPE_ARRAY:
			var serialized:Array = []
			for v:Variant in variant:
				serialized.append(_serialize(v))
			return serialized
		TYPE_DICTIONARY:
			var serialized:Dictionary = {}
			var variantDict: Dictionary = variant as Dictionary
			for key:Variant in variantDict.keys():
				serialized[str(key)] = _serialize(variantDict.get(key))
			return serialized
	
	if variant is Object:
		assert(false, variant + " passed as object instead of collection")
	return null
	
