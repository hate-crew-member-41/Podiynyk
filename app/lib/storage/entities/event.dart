import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'subject.dart';
import 'entity.dart';


class Event implements StoredEntity {
	final String id;
	final String name;
	final Subject? subject;
	final DateTime date;
	late bool isShown;

	String? note;

	Event.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.subject}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate()
	{
		isShown = Local.entityIsUnstored(Field.hiddenEvents, this);
	}

	Future<void> addDetails() => Cloud.addEventDetails(this);

	void hide() {
		Local.storeEntity(Field.hiddenEvents, this);
		isShown = false;
	}

	void show() {
		Local.deleteEntity(Field.hiddenEvents, this);
		isShown = true;
	}

	@override
	String get essence => '${subject?.essence}.$name';
}
