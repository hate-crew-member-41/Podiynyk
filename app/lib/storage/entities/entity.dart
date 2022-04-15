import 'package:flutter/foundation.dart';

import '../cloud.dart';
import '../local.dart';
import '../identifier.dart';


@immutable
abstract class Entity implements Comparable {
	Entity({
		required this.id,
		required this.name,
		this.label,
		this.hasDetails = false
	});

	Entity.created({required this.name}) :
		id = newId,
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

	Entity.modified(Entity entity, {
		String? name,
		String? nameRepr
	}) :
		id = entity.id,
		name = name ?? entity.name,
		hasDetails = entity.hasDetails
	{
		if (nameRepr != null) {
			if (nameRepr.isNotEmpty && nameRepr != this.name) {
				label = nameRepr;
				Local.storeEntityLabel(this);
			}
			else if (entity.label != null) {
				label = null;
				Local.deleteEntityLabel(this);
			}
			else {
				label = entity.label;
			}
		}
		else {
			label = entity.label;
		}
	}

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

	Collection? get cloudCollection => null;
	Identifier? get labelCollection => null;

	@override
	int compareTo(covariant Entity other) => nameRepr.compareTo(other.nameRepr);

	static String get newId => DateTime.now().microsecondsSinceEpoch.toString().substring(2);
}
