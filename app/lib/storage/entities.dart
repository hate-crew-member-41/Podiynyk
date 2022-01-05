/// The student's [Role] in the group.
enum Role {
	/// Views the group's content. Multiple students in the group have this role.
	ordinary,
	/// Manages the group's content. Multiple students in the group have this role.
	trusted,
	/// Manages the group's [trusted] students. A single student in the group has this role.
	leader,
}

extension Comparing on Role {
	bool operator <(Role comparedTo) {
		return index < comparedTo.index;
	}
}


class Subject {
	final String name;
	final DateTime nextEventDate;
	final int eventCount;
	final int totalEventCount;

	const Subject({
		required this.name,
		required this.nextEventDate,
		required this.eventCount,
		required this.totalEventCount
	});
}
