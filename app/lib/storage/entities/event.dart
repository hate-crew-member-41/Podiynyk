import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event {
	final String id;
	final String _name;
	late String? _label;
	final String? subjectName;
	final DateTime date;
	late bool isShown;

	String? note;

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		_name = entry.value[Field.name.name] as String,
		subjectName = entry.value[Field.subject.name],
		date = (entry.value[Field.date.name] as Timestamp).toDate()
	{
		_label = Local.entityLabel(Field.events, essence);
		isShown = Local.entityIsUnstored(Field.hiddenEvents, essence);
	}

	String get name => _label ?? _name;

	set label(String label) {
		if (label == _label) return;

		if (label.isEmpty || label == _name) {
			Local.deleteEntityLabel(Field.events, essence);
			_label = null;
		}
		else {
			Local.setEntityLabel(Field.events, essence, label);
			_label = label;
		}
	}

	Future<void> addDetails() => Cloud.addEventDetails(this);

	void hide() {
		Local.storeEntity(Field.hiddenEvents, essence);
		isShown = false;
	}

	void show() {
		Local.deleteEntity(Field.hiddenEvents, essence);
		isShown = true;
	}

	String get essence => '$subjectName.$_name';
}
