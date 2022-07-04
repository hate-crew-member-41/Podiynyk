import 'package:podiinyk/core/data/types.dart';

import 'student.dart';


class Message {
	const Message({
		required this.id,
		required this.name,
		required this.content,
		required this.author,
		required this.datetime
	});

	Message.fromCloud({
		required this.id,
		required ObjectMap object,
		required Map<String, Student> students
	}) :
		name = object[Field.name.name],
		content = object[Field.content.name],
		author = students[object[Field.author.name]]!,
		datetime = object[Field.datetime.name];

	final String id;
	final String name;
	final String content;
	final Student author;
	final DateTime datetime;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		Field.content.name: content,
		Field.author.name: author,
		Field.datetime.name: datetime
	};
}
