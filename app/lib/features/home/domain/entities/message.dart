import 'package:podiinyk/core/domain/types/date.dart';

import 'student.dart';


class Message {
	const Message({
		required this.id,
		required this.name,
		required this.content,
		required this.author,
		required this.date,
	});

	final String id;
	final String name;
	final String content;
	final Student author;
	final Date date;
}
