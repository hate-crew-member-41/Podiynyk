import 'package:cloud_firestore/cloud_firestore.dart'
;
import '../../types/entity_date.dart';
import '../../types/field.dart';
import '../../types/object_map.dart';

import 'student.dart';


class Message {
	Message({
		required this.id,
		required this.name,
		required this.content,
	}) :
		author = const Student.user(),
		date = EntityDate.now();

	Message.fromCloud({
		required this.id,
		required ObjectMap object,
		required Map<String, Student> students
	}) :
		name = object[Field.name.name],
		content = object[Field.content.name],
		author = students[object[Field.author.name]]!,
		date = EntityDate(
			(object[Field.date.name] as Timestamp).toDate(),
			hasTime: true
		);

	final String id;
	final String name;
	final String content;
	final Student author;
	final EntityDate date;

	ObjectMap get cloudObject => {
		Field.name.name: name,
		Field.content.name: content,
		Field.author.name: author.id,
		Field.date.name: date
	};
}
