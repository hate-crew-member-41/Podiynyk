import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'labelable.dart';


class Student extends LabelableEntity implements Comparable {
	Student({required String name}) :
		confirmationCount = null,
		super(
			idComponents: [name],
			name: name
		);

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

	@override
	set nameRepr(String repr) {
		if (name != Local.userName) {
			super.nameRepr = repr;
		}
		else if (repr != name && repr.isNotEmpty) {
			name = repr;
			Local.userName = repr;
			Cloud.updateName();
		}
	}

	Future<void> voteFor({String? previousId}) => Cloud.changeLeaderVote(toId: id, fromId: previousId);

	@override
	Field get labelCollection => Field.students;

	@override
	int compareTo(covariant Student other) => nameRepr.compareTo(other.nameRepr);
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
