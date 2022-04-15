import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../identifier.dart';

import 'entity.dart';
import 'student.dart';


class Message extends Entity {
	Message({
		required String name,
		required this.content
	}) :
		author = Student.user(),
		date = DateTime.now(),
		super.created(name: name);

	Message.fromCloud({required String id, required CloudMap object}) :
		author = Student.author(object[Identifier.author.name]),
		date = (object[Identifier.date.name] as Timestamp).toDate(),
		content = null,
		super.fromCloud(id: id, object: object);

	Message._withDetails({
		required Message message,
		required CloudMap details
	}) :
		author = message.author,
		date = message.date,
		content = details[Identifier.content.name] as String,
		super.withDetails(entity: message);

	Message.modified(Message message, {
		String? name,
		String? content
	}) :
		author = message.author,
		date = message.date,
		content = content ?? message.content,
		super.modified(message, name: name);

	final Student author;
	final DateTime date;

	final String? content;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name,
		Identifier.author.name: {
			Identifier.id.name: author.id,
			Identifier.name.name: author.name
		},
		Identifier.date.name: date
	};
	@override
	CloudMap get detailsInCloudFormat => {
		Identifier.content.name: content!
	};

	@override
	Future<Message> get withDetails async => Message._withDetails(
		message: this,
		details: await Cloud.entityDetails(this)
	);

	@override
	Collection get cloudCollection => Collection.messages;

	@override
	int compareTo(covariant Message other) => other.date.compareTo(date);
}
