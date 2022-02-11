import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart' show Cloud;
import '../fields.dart';
import 'entity.dart';


typedef MessageEssence = String;


class Message implements DetailedEntity, StoredEntity<MessageEssence> {
	final String id;
	final String subject;
	final DateTime date;

	String? author;
	String? content;

	Message.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		subject = entry.value[Field.subject.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

	@override
	Future<void> addDetails() => Cloud.addMessageDetails(this);

	@override
	MessageEssence get essence => subject;

	@override
	bool essenceIs(MessageEssence comparedTo) => subject == comparedTo;
}
