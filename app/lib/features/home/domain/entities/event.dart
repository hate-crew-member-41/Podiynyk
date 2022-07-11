import 'package:podiinyk/core/domain/types/date.dart';

import 'subject.dart';


class Event {
	Event({
		required this.id,
		required this.name,
		this.subject,
		required this.date,
		this.note
	});

	final String id;
	final String name;
	final Subject? subject;
	final Date date;
	final String? note;
}
