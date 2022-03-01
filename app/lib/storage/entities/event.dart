import 'package:cloud_firestore/cloud_firestore.dart';

import 'labelable.dart';
import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event extends LabelableEntity implements Comparable {
	final String id;
	final String? subjectName;
	late final String? subjectLabel;
	DateTime date;
	late bool isHidden;

	String? note;

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		subjectName = entry.value[Field.subject.name],
		date = (entry.value[Field.date.name] as Timestamp).toDate(),
		super(initialName: entry.value[Field.name.name] as String)
	{
		subjectLabel = subjectName != null ? Local.entityLabel(Field.subjects, subjectName!) : null;
		isHidden = Local.entityIsStored(Field.hiddenEvents, essence);
	}

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.events, id);
		note = details[Field.note.name];
	}

	@override
	Field get labelCollection => Field.events;

	void hide() {
		Local.storeEntity(Field.hiddenEvents, essence);
		isHidden = true;
	}

	void show() {
		Local.deleteEntity(Field.hiddenEvents, essence);
		isHidden = false;
	}

	@override
	String get essence => '$subjectName.$initialName';

	@override
	int compareTo(dynamic other) => date.compareTo(other.date);
}
