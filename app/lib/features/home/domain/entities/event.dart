import 'package:podiinyk/core/domain/types/date.dart';

import 'entity.dart';
import 'subject.dart';


class Event extends Entity {
	const Event({
		required String id,
		required this.name,
		this.subject,
		required this.date,
		this.note
	}) :
		super(id: id);

	final String name;
	final Subject? subject;
	final Date date;
	final String? note;

	@override
	int compareTo(covariant Event other) => date.compareTo(other.date);
}
