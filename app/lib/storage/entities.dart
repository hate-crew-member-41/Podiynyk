/// The student's [Role] in a group.
enum Role {
	/// Views the group's content. Multiple students in a group have this role.
	ordinary,
	/// Manages the group's content. Multiple students in a group have this role.
	trusted,
	/// Manages the group's [trusted] students. A single student in a group has this role.
	leader,
}

extension Comparing on Role {
	bool operator >=(Role comparedTo) {
		return index >= comparedTo.index;
	}
}
