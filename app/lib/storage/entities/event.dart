import 'package:cloud_firestore/cloud_firestore.dart';

import 'labelable.dart';
import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event extends LabelableEntity {
	final String id;
	final String? subjectName;
	final DateTime date;
	late bool isShown;

	String? note;

	// tofix: take the subject's label into account
	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		subjectName = entry.value[Field.subject.name],
		date = (entry.value[Field.date.name] as Timestamp).toDate(),
		super(initialName: entry.value[Field.name.name] as String)
	{
		isShown = Local.entityIsNotStored(Field.hiddenEvents, essence);
	}

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.events, id);
		note = details[Field.note.name];
	}

	@override
	Field get labelCollection => Field.events;

	void hide() {
		Local.storeEntity(Field.hiddenEvents, essence);
		isShown = false;
	}

	void show() {
		Local.deleteEntity(Field.hiddenEvents, essence);
		isShown = true;
	}

	@override
	String get essence => '$subjectName.$initialName';
}
