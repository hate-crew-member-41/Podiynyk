import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../identifier.dart';
import '../local.dart';

import 'entity.dart';
import 'subject.dart';


class Event extends Entity {
	Event({
		required String name,
		this.subject,
		required this.date,
		this.note
	}) :
		isHidden = false,
		super.created(name: name);

	Event.fromCloud({required String id, required CloudMap object}) :
		subject = object.containsKey(Identifier.subject.name) ? Subject.ofEvent(object[Identifier.subject.name]) : null,
		date = (object[Identifier.date.name] as Timestamp).toDate(),
		note = null,
		super.fromCloud(id: id, object: object)
	{
		isHidden = Local.entityIsStored(Identifier.hiddenEvents, this);
	}

	Event._withDetails({required Event event, required CloudMap details}) :
		subject = event.subject,
		date = event.date,
		isHidden = event.isHidden,
		note = details[Identifier.note.name],
		super.withDetails(entity: event);
	
	Event.modified({
		required Event event,
		String? nameRepr,
		DateTime? date,
		bool? hidden,
		String? note
	}) :
		subject = event.subject,
		date = date ?? event.date,
		isHidden = hidden ?? event.isHidden,
		note = note != null ? (note.isNotEmpty ? note : null) : event.note,
		super.modified(entity: event, nameRepr: nameRepr)
	{
		if (hidden == true) {
			Local.storeEntity(Identifier.hiddenEvents, this);
		}
		else if (hidden == false) {
			Local.deleteEntity(Identifier.hiddenEvents, this);
		}
	}

	final Subject? subject;
	final DateTime date;
	late final bool isHidden;

	final String? note;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name,
		if (subject != null) Identifier.subject.name: {
			Identifier.id.name: subject!.id,
			Identifier.name.name: subject!.name
		},
		Identifier.date.name: date
	};
	@override
	CloudMap get detailsInCloudFormat => {
		if (note != null) Identifier.note.name: note
	};

	@override
	Future<Event> get withDetails async => Event._withDetails(
		event: this,
		details: await Cloud.entityDetails(this)
	);

	@override
	Collection get cloudCollection => Collection.events;
	@override
	Identifier get labelCollection => Identifier.events;

	static String countRepr(int count) {
		if (count > 1) return "$count events";
		if (count == 1) return "1 event";
		return "no events";
	}

	@override
	int compareTo(covariant Event other) => date.compareTo(other.date);
}
