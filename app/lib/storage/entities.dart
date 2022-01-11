import 'cloud.dart' show Cloud;


class Student {
	final String name;
	final Role role;

	const Student({
		required this.name,
		required this.role
	});
}

enum Role {
	/// Views the group's content. Multiple students in the group have this role.
	ordinary,
	/// Manages the group's content. Multiple students in the group have this role.
	trusted,
	/// Manages the group's [trusted] students. A single student in the group has this role.
	leader,
}

extension Compared on Role {
	bool operator <(Role comparedTo) => index < comparedTo.index;
}


class Subject {
	final String id;
	final String name;
	final List<Event> events;

	int? totalEventCount;
	List<String>? info;

	Subject({
		required this.id,
		required this.name,
		required this.events
	});

	Future<void> addDetails() => Cloud.addSubjectDetails(this);

	String get eventCountRepr => _eventCountRepr(events.length);

	String get totalEventCountRepr => _eventCountRepr(totalEventCount!);

	String _eventCountRepr(int count) {
		switch (count.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$count events";
		}
	}
}


class Event {
	final String id;
	final String name;
	final String? subject;
	final DateTime date;

	String? note;

	Event({
		required this.id,
		required this.name,
		required this.subject,
		required this.date
	});

	Future<void> addDetails() => Cloud.addEventDetails(this);

	bool isBefore(Event event) => date.isBefore(event.date);
}


class Message {
	final String id;
	final String subject;
	final DateTime date;

	String? author;
	String? content;

	Message({
		required this.id,
		required this.subject,
		required this.date
	});

	Future<void> addDetails() => Cloud.addMessageDetails(this);
}


// todo: define
class Question {
	const Question();
}
