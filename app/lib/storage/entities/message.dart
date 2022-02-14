import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';


class Message {
	final String id;
	final String name;
	final DateTime date;

	String? author;
	String? content;

	Message.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.messages, id);
		content = details[Field.message.name];
		author = details[Field.author.name];
	}
}
