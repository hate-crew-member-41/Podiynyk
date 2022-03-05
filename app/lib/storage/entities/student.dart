import '../cloud.dart';

import 'labelable.dart';
import '../fields.dart';


class Student extends LabelableEntity implements Comparable {
	final String id;
	final int? confirmationCount;

	Role? _role;
	Role get role => _role!;
	set role(Role role) {
		_role = role;

		if (_role != Role.leader) {
			Cloud.updateRole(this);
		}
		else {
			Cloud.makeLeader(this);
			_role = Role.trusted;
		}
	}

	Student.candidateFromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		_role = null,
		confirmationCount = entry.value[Field.confirmationCount.name] as int,
		super(initialName: entry.value[Field.name.name] as String);

	Student.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		_role = Role.values[entry.value[Field.role.name] as int],
		confirmationCount = null,
		super(initialName: entry.value[Field.name.name] as String);

	@override
	Field get labelCollection => Field.students;

	@override
	int compareTo(dynamic other) => name.compareTo(other.name);
	int compareIdTo(Student other) => int.parse(id).compareTo(int.parse(other.id));
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
