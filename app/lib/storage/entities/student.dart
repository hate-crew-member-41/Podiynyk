import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

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
	
	Future<void> voteFor({String? previousId}) => Cloud.changeLeaderVote(toId: id, fromId: previousId);

	Student.fromCloudFormat(MapEntry<String, dynamic> entry) :
		_role = Role.values[entry.value[Field.role.name] as int],
		confirmationCount = null,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);
	
	@override
	set label(String label) {
		if (name != Local.name) {
			super.label = label;
		}
		else if (label != name && label.isNotEmpty) {
			name = label;
			Local.name = label;
			Cloud.updateName();
		}
	}

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
