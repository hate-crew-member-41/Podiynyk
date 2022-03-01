import 'package:cloud_firestore/cloud_firestore.dart';

import 'labelable.dart';
import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event extends LabelableEntity implements Comparable {
	final String id;
	final String? subjectName;
	late final String? subjectLabel;

	DateTime _date;
	DateTime get date => _date;
	set date(DateTime date) {
		if (date == _date) return;
		_date = date;
		Cloud.updateEventDate(this);
	}

	late bool _isHidden;
	bool get isHidden => _isHidden;
	set isHidden(bool isHidden) {
		_isHidden = isHidden;
		_isHidden ? Local.storeEntity(Field.hiddenEvents, essence) : Local.deleteEntity(Field.hiddenEvents, essence);
	}

	String? _note;
	String? get note => _note;
	set note(String? note) {
		if (note == _note) return;
		_note = note;
		Cloud.updateEventNote(this);
	}

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		subjectName = entry.value[Field.subject.name],
		_date = (entry.value[Field.date.name] as Timestamp).toDate(),
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

	@override
	String get essence => '$subjectName.$initialName';

	@override
	int compareTo(dynamic other) => date.compareTo(other.date);
}
