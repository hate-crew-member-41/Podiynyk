import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart' show Cloud;
import '../fields.dart';
import 'subject.dart';


class Event {
	final String id;
	final String name;
	final Subject? subject;
	final DateTime date;

	String? note;

	Event.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.subject}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

	Future<void> addDetails() => Cloud.addEventDetails(this);

	bool isBefore(Event event) => date.isBefore(event.date);
}
