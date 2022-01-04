import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Roles = Map<String, Role>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	static Role get role => _role;

	/// The [roles] of the group's students. Updates the user's [Role].
	static Future<Roles> roles() async {
		final rawRoles = await _cloud.collection('students').doc(Local.groupId).get();
		final roles = {
			for (final studentRole in rawRoles.data()!.entries)
			studentRole.key: Role.values[studentRole.value as int]
		};

		_role = roles[Local.name]!;
		return roles;
	}
}
