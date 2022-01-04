import 'dart:math' show min, max;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Document = DocumentReference<Map<String, dynamic>>;
typedef Roles = Map<String, Role>;
typedef Subjects = Map<String, Map<String, Object>>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	static Role get role => _role;

	/// The [roles] of the group's students. Updates the user's [Role].
	static Future<Roles> roles() async {
		final rawRoles = await _document('students').get();
		final roles = {
			for (final studentRole in rawRoles.data()!.entries)
			studentRole.key: Role.values[studentRole.value as int]
		};

		_role = roles[Local.name]!;
		return roles;
	}

	/// Adds a new subject with the given [name].
	static Future<void> addSubject(String name) {
		final document = _document('subjects');

		return _cloud.runTransaction((transaction) async {
			final rawSubjects = await transaction.get(document);
			if (
				rawSubjects.exists &&
				rawSubjects.data()!.values.map((subject) => subject['name']).contains(name)
			) return;

			int id = 0;
			if (rawSubjects.exists) {
				final takenIds = rawSubjects.data()!.keys;
				while (takenIds.contains(id.toString())) id++;
			}

			final newSubject = {id.toString(): {
				'name': name,
				'total_event_count': 0
			}};

			if (rawSubjects.exists) {
				transaction.update(document, newSubject);
			}
			else {
				transaction.set(document, newSubject);
			}
		});
	}

	static Document _document(String dataType) => _cloud.collection(dataType).doc(Local.groupId);
}
