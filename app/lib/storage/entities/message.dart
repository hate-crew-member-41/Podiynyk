import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart' show Cloud;
import '../fields.dart';


class Message {
	final String id;
	final String topic;
	final DateTime date;

	String? author;
	String? content;

	Message.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		topic = entry.value[Field.subject.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

	Future<void> addDetails() => Cloud.addMessageDetails(this);
}
