import 'package:podiinyk/data/core/types/identifier.dart';
import 'package:podiinyk/data/core/types/object_map.dart';


class Subject {
	Subject.fromCloud({
		required this.id,
		required ObjectMap object
	}) :
		isCommon = object[Identifier.isCommon.name],
		name = object[Identifier.name.name];

	final String id;
	final String name;
	final bool isCommon;
}
