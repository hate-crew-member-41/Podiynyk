import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event {
	final String id;
	final String name;
	final String? subjectName;
	final DateTime date;
	late bool isShown;

	String? note;

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		subjectName = entry.value[Field.subject.name],
		date = (entry.value[Field.date.name] as Timestamp).toDate()
	{
		isShown = Local.entityEssenceIsUnstored(Field.hiddenEvents, essence);
	}

	Future<void> addDetails() => Cloud.addEventDetails(this);

	void hide() {
		Local.storeEntityEssence(Field.hiddenEvents, essence);
		isShown = false;
	}

	void show() {
		Local.deleteEntityEssence(Field.hiddenEvents, essence);
		isShown = true;
	}

	String get essence => '$subjectName.$name';
}
