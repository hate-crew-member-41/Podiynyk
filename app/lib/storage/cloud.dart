import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Document = DocumentReference<Map<String, dynamic>>;
typedef Roles = Map<String, Role>;
typedef Subjects = Map<String, Map<String, Object>>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	/// The user's [role] in the group.
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

	// todo: make addSubject and addEvent share logic (define _addEntity)
	/// Adds a new subject with the given [name].
	static Future<void> addSubject({required String name}) {
		final document = _document('subjects');

		return _cloud.runTransaction((transaction) async {
			final subjectsSnapshot = await transaction.get(document);
			int id = 0;

			if (subjectsSnapshot.exists) {
				final rawSubjects = subjectsSnapshot.data()!;

				for (final subject in rawSubjects.values) {
					if (subject['name'] == name) return;
				}

				final takenIds = rawSubjects.keys;
				while (takenIds.contains(id.toString())) id++;
			}

			final subject = {id.toString(): {
				'name': name,
				'total_event_count': 0
			}};

			if (subjectsSnapshot.exists) {
				transaction.update(document, subject);
			}
			else {
				transaction.set(document, subject);
			}
		});
	}

	/// Adds a new event with the given arguments.
	static Future<void> addEvent({
		required String name,
		String? subject,
		required DateTime date,
		String? note
	}) async {
		final document = _document('events');

		final id = await _cloud.runTransaction((transaction) async {
			final eventsSnapshot = await transaction.get(document);
			int intId = 0;

			if (eventsSnapshot.exists) {
				final rawEvents = eventsSnapshot.data()!;

				for (final event in rawEvents.values) {
					if (event['name'] == name && event['subject'] == subject) return null;
				}

				final takenIds = rawEvents.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final event = {id: {
				'name': name,
				if (subject != null) 'subject': subject,
				'date': date,
			}};

			if (eventsSnapshot.exists) {
				transaction.update(document, event);
			}
			else {
				transaction.set(document, event);
			}

			return id;
		});

		if (note != null && id != null) {
			document.collection('details').doc(id).set({'note': note});
		}
	}

	/// [DocumentReference] to the group's document for the given [dataType].
	static Document _document(String dataType) => _cloud.collection(dataType).doc(Local.groupId);
}
