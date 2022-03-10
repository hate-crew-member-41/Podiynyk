import '../cloud.dart';
import '../fields.dart';

import 'labelable.dart';


class Student extends LabelableEntity implements Comparable {
	final int? confirmationCount;

	Student.candidateFromCloudFormat(MapEntry<String, dynamic> entry) :
		_role = null,
		confirmationCount = entry.value[Field.confirmationCount.name] as int,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);

	Student.fromCloudFormat(MapEntry<String, dynamic> entry) :
		_role = Role.values[entry.value[Field.role.name] as int],
		confirmationCount = null,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);

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

	Future<void> voteFor({String? previousId}) => Cloud.changeLeaderVote(toId: id, fromId: previousId);

	@override
	Field get labelCollection => Field.students;

	@override
	int compareTo(covariant Student other) => nameRepr.compareTo(other.nameRepr);
	int compareIdTo(Student other) => int.parse(id).compareTo(int.parse(other.id));
}


/// The [Role] of a [Student] in their group.
enum Role {
	/// Views the group's content. Multiple [Student]s in the group can have this [Role].
	ordinary,
	/// Manages the group's content. Multiple [Student]s in the group can have this [Role].
	trusted,
	/// Manages the group's [trusted] [Student]s. A single [Student] in the group has this [Role].
	leader,
}
