import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'creatable.dart';
import 'labelable.dart';
import 'subject.dart';


class Event extends LabelableEntity implements CreatableEntity, Comparable {
	Event({
		required String name,
		required this.subject,
		required DateTime date,
		String? note
	}) :
		_date = date,
		_note = note,
		_hasDetails = true,
		super(
			idComponents: [subject, name],
			name: name
		);

	Event.fromCloudFormat(MapEntry<String, dynamic> entry) :
		subject = entry.value[Field.subject.name] != null ?
			Subject.name(name: entry.value[Field.subject.name] as String) :
			null,
		_date = (entry.value[Field.date.name] as Timestamp).toDate(),
		_hasDetails = false,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);
	
	final Subject? subject;

	DateTime _date;
	DateTime get date => _date;
	set date(DateTime date) {
		if (date == _date) return;
		_date = date;
		Cloud.updateEventDate(this);
	}

	late String? _note;
	String? get note => _note;
	set note(String? note) {
		if (note == _note) return;
		_note = note;
		Cloud.updateEventNote(this);
	}

	bool _hasDetails;
	bool get hasDetails => _hasDetails;

	bool get isHidden => Local.entityIsStored(Field.hiddenEvents, id);
	set isHidden(bool isHidden) {
		isHidden ? Local.storeEntity(Field.hiddenEvents, id) : Local.deleteEntity(Field.hiddenEvents, id);
	}

	Future<void> addDetails() async {
		if (_hasDetails) return;

		final details = await Cloud.entityDetails(Collection.events, id);
		_note = details[Field.note.name];
		_hasDetails = true;
	}

	@override
	CloudMap get inCloudFormat => {
		Field.name.name: name,
		Field.subject.name: subject?.name,
		Field.date.name: _date,
	};

	@override
	CloudMap get detailsInCloudFormat => {
		if (note != null) Field.note.name: note
	};

	@override
	Field get labelCollection => Field.events;

	@override
	int compareTo(covariant Event other) => date.compareTo(other.date);
}
