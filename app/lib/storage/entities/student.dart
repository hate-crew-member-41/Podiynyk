import 'labelable.dart';
import '../fields.dart';


class Student extends LabelableEntity {
	final String id;
	final Role? role;
	final int? confirmationCount;

	Student.candidateFromCloudFormat(this.id, {required Map<String, dynamic> data}) :
		role = null,
		confirmationCount = data[Field.confirmationCounts.name][id] as int,
		super(initialName: data[Field.names.name][id] as String);

	Student.fromCloudFormat(this.id, {required Map<String, dynamic> data}) :
		role = Role.values[data[Field.roles.name][id] as int],
		confirmationCount = null,
		super(initialName: data[Field.names.name][id] as String);

	@override
	Field get labelCollection => Field.students;

	@override
	String get essence => initialName;
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
