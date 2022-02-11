import '../fields.dart';


class Student {
	final String id;
	final String name;
	final Role? role;
	final int? confirmationCount;

	Student.candidateFromCloudFormat(this.id, {required Map<String, dynamic> data}) :
		name = data[Field.names.name][id] as String,
		role = null,
		confirmationCount = data[Field.confirmationCounts.name][id] as int;
	
	Student.fromCloudFormat(this.id, {required Map<String, dynamic> data}) :
		name = data[Field.names.name][id] as String,
		role = Role.values[data[Field.roles.name][id] as int],
		confirmationCount = null;
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
