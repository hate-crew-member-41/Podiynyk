import 'package:cloud_firestore/cloud_firestore.dart';

import 'labelable.dart';
import '../cloud.dart';
import '../fields.dart';
import '../local.dart';


class Event extends LabelableEntity implements Comparable {
	final String? subject;
	late final String? _subjectLabel;

	Event({
		required String name,
		required this.subject,
		required DateTime date,
		String? note
	}) :
		_date = date,
		_note = note,
		super(name: name);

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		subject = entry.value[Field.subject.name],
		_date = (entry.value[Field.date.name] as Timestamp).toDate(),
		super(name: entry.value[Field.name.name] as String)
	{
		_subjectLabel = subject != null ? Local.entityLabel(Field.subjects, subject!) : null;
		_isHidden = Local.entityIsStored(Field.hiddenEvents, id);
	}

	CloudMap get inCloudFormat => {
		Field.name.name: name,
		Field.subject.name: subject,
		Field.date.name: _date,
	};

	CloudMap get detailsInCloudFormat => {
		if (note != null) Field.note.name: note
	};

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
		_isHidden ? Local.storeEntity(Field.hiddenEvents, id) : Local.deleteEntity(Field.hiddenEvents, id);
	}

	String? _note;
	String? get note => _note;
	set note(String? note) {
		if (note == _note) return;
		_note = note;
		Cloud.updateEventNote(this);
	}

	String? get subjectNameRepr => _subjectLabel ?? subject;

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.events, id);
		_note = details[Field.note.name];
	}

	@override
	List<dynamic> get idComponents => [subject, name];

	@override
	Field get labelCollection => Field.events;

	@override
	int compareTo(covariant Event other) => date.compareTo(other.date);
}
