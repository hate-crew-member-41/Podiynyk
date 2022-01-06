import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Document = DocumentReference<Map<String, dynamic>>;
typedef Roles = Map<String, Role>;
typedef Events = Map<String, Map<String, Object>>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	/// The user's [Role] in the group.
	static Role get role => _role;

	/// The [Roles] of the group's students. Updates the user's [Role].
	static Future<Roles> roles() async {
		final rawRoles = await _document(Collection.students).get();
		final roles = {
			for (final studentRole in rawRoles.data()!.entries)
			studentRole.key: Role.values[studentRole.value as int]
		};

		_role = roles[Local.name]!;
		return roles;
	}

	// todo: make [add{entity}]s share code (define _addEntity)

	/// Adds a subject with the given [name] unless it exists.
	static Future<void> addSubject({required String name}) async {
		final document = _document(Collection.subjects);

		final id = await _cloud.runTransaction((transaction) async {
			final subjectsSnapshot = await transaction.get(document);
			int intId = 0;

			if (subjectsSnapshot.exists) {
				final subjectEntries = subjectsSnapshot.data()!;

				for (final subjectName in subjectEntries.values) {
					if (subjectName == name) return null;
				}

				final takenIds = subjectEntries.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final subjectEntry = {id: name};

			if (subjectsSnapshot.exists) {
				transaction.update(document, subjectEntry);
			}
			else {
				transaction.set(document, subjectEntry);
			}

			return id;
		});

		if (id != null) {
			document.collection(Collection.details).doc(id).set({Field.totalEventCount: 0});
		}
	}

	/// The names of the group's subjects.
	static Future<List<String>> subjectNames() async {
		final subjectsSnapshot = await _document(Collection.subjects).get();
		return subjectsSnapshot.exists ? List<String>.from(subjectsSnapshot.data()!.values) : [];
	}

	/// The group's [subjects].
	static Future<List<Subject>> subjects() async {
		final snapshots = await Future.wait([
			_document(Collection.subjects).get(),
			_document(Collection.events).get()
		]);
		final subjectNames = (snapshots.first.data() ?? {}).values;
		final eventEntries = (snapshots.last.data() ?? {}) as Events;

		final subjectsEvents = {for (final subject in subjectNames) subject: <Event>[]};

		for (final event in eventEntries.values) {
			subjectsEvents[event[Field.subject]]!.add(Event(
				name: event[Field.name] as String,
				subject: event[Field.subject] as String?,
				date: event[Field.date] as DateTime
			));
		}

		return [for (final subjectName in subjectNames) Subject(
			name: subjectName,
			events: subjectsEvents[subjectName]!
		)];
	}

	/// Adds an event with the given arguments unless it exists.
	static Future<void> addEvent({
		required String name,
		String? subject,
		required DateTime date,
		String? note
	}) async {
		final document = _document(Collection.events);

		final id = await _cloud.runTransaction((transaction) async {
			final eventsSnapshot = await transaction.get(document);
			int intId = 0;

			if (eventsSnapshot.exists) {
				final eventEntries = eventsSnapshot.data()!;

				for (final existingEvent in eventEntries.values) {
					if (existingEvent[Field.name] == name && existingEvent[Field.subject] == subject) return null;
				}

				final takenIds = eventEntries.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final subjectsDocument = _document(Collection.subjects);
			final subjectsSnapshot = await transaction.get(subjectsDocument);
			final subjectId = subjectsSnapshot.data()!.entries.firstWhere(
				(subjectEntry) => subjectEntry.value == subject
			).key;

			final id = intId.toString();
			final eventEntry = {id: {
				Field.name: name,
				if (subject != null) Field.subject: subject,
				Field.date: date,
			}};

			if (eventsSnapshot.exists) {
				transaction.update(document, eventEntry);
			}
			else {
				transaction.set(document, eventEntry);
			}
			subjectsDocument.collection(Collection.details).doc(subjectId).update({
				Field.totalEventCount: FieldValue.increment(1)
			});

			return id;
		});

		if (note != null && id != null) {
			document.collection(Collection.details).doc(id).set({Field.note: note});
		}
	}

	/// Adds a message with the given arguments unless it exists.
	static Future<void> addMessage({
		required String subject,
		required String content
	}) async {
		final document = _document(Collection.messages);

		final id = await _cloud.runTransaction((transaction) async {
			final messagesSnapshot = await transaction.get(document);
			int intId = 0;

			if (messagesSnapshot.exists) {
				final messageEntries = messagesSnapshot.data()!;

				for (final existingMessageSubject in messageEntries.values) {
					if (existingMessageSubject == subject) return null;
				}

				final takenIds = messageEntries.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final messageEntry = {id: subject};

			if (messagesSnapshot.exists) {
				transaction.update(document, messageEntry);
			}
			else {
				transaction.set(document, messageEntry);
			}

			return id;
		});

		if (id != null) {
			document.collection(Collection.details).doc(id).set({Field.content: content});
		}
	}

	/// [DocumentReference] to the document with the given [entities] of the group.
	static Document _document(String entities) => _cloud.collection(entities).doc(Local.groupId);
}


/// The [Collection]s used in [FirebaseFirestore].
class Collection {
	static const students = 'students';
	static const subjects = 'subjects';
	static const events = 'events';
	static const details = 'details';
	static const messages = 'messages';
}

/// The fields used in [FirebaseFirestore].
class Field {
	static const name = 'name';
	static const totalEventCount = 'totalEventCount';
	static const subject = 'subject';
	static const date = 'date';
	static const note = 'note';
	static const content = 'content';
}
