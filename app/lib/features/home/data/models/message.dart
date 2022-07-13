import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/domain/types/date.dart';

import '../../domain/entities/message.dart';
import '../../domain/entities/student.dart';


class MessageModel extends Message {
	MessageModel(
		MapEntry<String, dynamic> entry,
		{required Iterable<Student> students}
	) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		content: entry.value[Field.content.name],
		author: students.firstWhere((s) => s.id == entry.value[Field.author.name]),
		date: Date((entry.value[Field.date.name] as Timestamp).toDate())
	);
}
