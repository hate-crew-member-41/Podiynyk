class Student {
	final String id;
	final String name;
	final Role role;

	const Student({
		required this.id,
		required this.name,
		required this.role
	});
}


/// The [Role] of a [Student] in their group.
enum Role {
	/// Views the group's content. Multiple [Student]s in the group have this [Role].
	ordinary,
	/// Manages the group's content. Multiple [Student]s in the group have this [Role].
	trusted,
	/// Manages the group's [trusted] [Student]s. A single [Student] in the group has this [Role].
	leader,
}

extension Compared on Role {
	bool operator <(Role comparedTo) => index < comparedTo.index;
}
