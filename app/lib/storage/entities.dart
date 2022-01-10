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
	final String name;
	final List<Event> events;

	Subject({
		required this.name,
		required this.events
	});
}


class Event {
	final String name;
	final String? subject;
	final DateTime date;

	const Event({
		required this.name,
		required this.subject,
		required this.date
	});

	bool isBefore(Event event) => date.isBefore(event.date);
}


class Message {
	final String id;
	final String subject;
	final DateTime date;

	String? content;
	String? author;

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
