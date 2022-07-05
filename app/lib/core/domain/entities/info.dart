import '../../types/field.dart';
import '../../types/object_map.dart';


class Info {
	const Info({
		required this.id,
		required this.name,
		required this.content
	});

	Info.fromCloud({
		required this.id,
		required ObjectMap object
	}) :
		name = object[Field.name.name],
		content = object[Field.content.name];

	final String id;
	final String name;
	final String content;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		Field.content.name: content
	};
}
