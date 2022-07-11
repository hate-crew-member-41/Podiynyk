import 'package:podiinyk/domain/core/types/entity_date.dart';
import 'package:podiinyk/domain/home/entities/subject.dart';


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
	final EntityDate date;
	final String? note;
}
