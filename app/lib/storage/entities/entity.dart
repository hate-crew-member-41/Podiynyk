import 'package:flutter/foundation.dart';

import '../cloud.dart';
import '../local.dart';
import '../identifiers.dart';


typedef EntityEntry = MapEntry<String, CloudMap>;


@immutable
abstract class Entity implements Comparable {
	Entity({
		required this.id,
		required this.name,
		this.label,
		this.hasDetails = false
	});

	Entity.created({required this.name}) :
		id = DateTime.now().microsecondsSinceEpoch.toString().substring(2),
		label = null,
		hasDetails = true;

	Entity.fromCloud({required this.id, required CloudMap object}) :
		name = object[Identifier.name.name] as String,
		hasDetails = false
	{
		_initLabel();
	}

	Entity.fromObject(CloudMap object) :
		id = object[Identifier.id.name] as String,
		name = object[Identifier.name.name] as String,
		hasDetails = false
	{
		_initLabel();
	}

	Entity.withDetails({required Entity entity}) :
		id = entity.id,
		name = entity.name,
		label = entity.label,
		hasDetails = true;

	// Entity.modified({required Entity entity, String? label}) :
	// 	id = entity.id,
	// 	name = entity.name,
	// 	label = label ?? entity.label,
	// 	hasDetails = entity.hasDetails;

	void _initLabel() {
		label = labelCollection != null ? Local.entityLabel(this) : null;
	}
 
	final String id;
	final String name;
	late final String? label;
	final bool hasDetails;

	String get nameRepr => label ?? name;

	CloudMap get inCloudFormat;
	CloudMap? get detailsInCloudFormat => null;

	Future<Entity>? get withDetails => null;

	EntityCollection? get cloudCollection => null;
	Identifier? get labelCollection => null;

	@override
	int compareTo(covariant Entity other) => nameRepr.compareTo(other.nameRepr);
}
