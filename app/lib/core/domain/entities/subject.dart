import '../../types/field.dart';
import '../../types/object_map.dart';


class Subject {
	const Subject({
		required this.id,
		required this.name,
		required this.isCommon
	});

	Subject.fromCloud({
		required this.id,
		required ObjectMap object
	}) :
		isCommon = object[Field.isCommon.name],
		name = object[Field.name.name];

	final String id;
	final String name;
	final bool isCommon;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		Field.isCommon.name: isCommon
	};
}
