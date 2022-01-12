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
