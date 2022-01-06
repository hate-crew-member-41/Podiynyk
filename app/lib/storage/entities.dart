/// The student's [Role] in the group.
enum Role {
	/// Views the group's content. Multiple students in the group have this role.
	ordinary,
	/// Manages the group's content. Multiple students in the group have this role.
	trusted,
	/// Manages the group's [trusted] students. A single student in the group has this role.
	leader,
}

extension Compared on Role {
	bool operator <(Role comparedTo) {
		return index < comparedTo.index;
	}
}


class Subject {
	final String name;
	final List<Event> events;

	const Subject({
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
	final String subject;
	final DateTime date;

	const Message({
		required this.subject,
		required this.date
	});
}
