import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Document = DocumentReference<Map<String, dynamic>>;
typedef Roles = Map<String, Role>;
typedef Entities = Map<String, Map<String, Object>>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	/// The user's [role] in the group.
	static Role get role => _role;

	/// The [roles] of the group's students. Updates the user's [Role].
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

	/// Adds a new subject with the given [name].
	static Future<void> addSubject({required String name}) {
		final document = _document(Collection.subjects);

		return _cloud.runTransaction((transaction) async {
			final subjectsSnapshot = await transaction.get(document);
			int intId = 0;

			if (subjectsSnapshot.exists) {
				final rawSubjects = subjectsSnapshot.data()!;

				for (final subject in rawSubjects.values) {
					if (subject[Field.name] == name) return;
				}

				final takenIds = rawSubjects.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final subject = {intId.toString(): {
				Field.name: name,
				Field.totalEventCount: 0
			}};

			if (subjectsSnapshot.exists) {
				transaction.update(document, subject);
			}
			else {
				transaction.set(document, subject);
			}
		});
	}

	/// The names of the group's subjects.
	static Future<List<String>> subjectNames() async {
		final subjectsSnapshot = await _document(Collection.subjects).get();
		return subjectsSnapshot.exists ? [
			for (final subject in subjectsSnapshot.data()!.values) subject[Field.name]
		] : [];
	}

	/// The group's [subjects].
	static Future<List<Subject>> subjects() async {
		final snapshots = await Future.wait([
			_document(Collection.subjects).get(),
			_document(Collection.events).get()
		]);
		final subjects = (snapshots.first.data() ?? {}) as Entities;
		final events = (snapshots.last.data() ?? {}) as Entities;

		final nextEventDates = <String, DateTime>{};
		final eventCounts = {for (final name in subjects.keys) name: 0};

		for (final event in events.values) {
			final subject = event[Field.subject] as String;
			final date = event[Field.date] as DateTime;

			nextEventDates.update(
				subject,
				(subjectNextEventDate) => date.isAfter(subjectNextEventDate) ? date : subjectNextEventDate,
				ifAbsent: () => date
			);
			eventCounts.update(subject, (count) => ++count);
		}

		return [for (final subject in subjects.entries) Subject(
			name: subject.key,
			nextEventDate: nextEventDates[subject.key]!,
			eventCount: eventCounts[subject.key]!,
			totalEventCount: subject.value[Field.totalEventCount] as int
		)];
	}

	/// Adds a new event with the given arguments.
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
				final rawEvents = eventsSnapshot.data()!;

				for (final event in rawEvents.values) {
					if (event[Field.name] == name && event[Field.subject] == subject) return null;
				}

				final takenIds = rawEvents.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final subjectsDocument = _document(Collection.subjects);
			final subjectsSnapshot = await transaction.get(subjectsDocument);
			final subjectId = subjectsSnapshot.data()!.entries.firstWhere(
				(subjectEntry) => subjectEntry.value[Field.name] == subject
			).key;

			final id = intId.toString();
			final event = {id: {
				Field.name: name,
				if (subject != null) Field.subject: subject,
				Field.date: date,
			}};

			if (eventsSnapshot.exists) {
				transaction.update(document, event);
			}
			else {
				transaction.set(document, event);
			}
			transaction.update(subjectsDocument, {'$subjectId.${Field.totalEventCount}': FieldValue.increment(1)});

			return id;
		});

		if (note != null && id != null) {
			document.collection(Collection.details).doc(id).set({Field.note: note});
		}
	}

	static Future<void> addMessage({
		required String subject,
		required String content
	}) async {
		final document = _document(Collection.messages);

		final id = await _cloud.runTransaction((transaction) async {
			final messagesSnapshot = await transaction.get(document);
			int intId = 0;

			if (messagesSnapshot.exists) {
				final rawMessages = messagesSnapshot.data()!;

				for (final existingSubject in rawMessages.values) {
					if (existingSubject == subject) return null;
				}

				final takenIds = rawMessages.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final messageSubject = {id: subject};

			if (messagesSnapshot.exists) {
				transaction.update(document, messageSubject);
			}
			else {
				transaction.set(document, messageSubject);
			}

			return id;
		});

		if (id != null) {
			document.collection(Collection.details).doc(id).set({Field.content: content});
		}
	}

	/// [DocumentReference] to the group's document for the given [entities].
	static Document _document(String entities) => _cloud.collection(entities).doc(Local.groupId);
}


class Collection {
	static const students = 'students';
	static const subjects = 'subjects';
	static const events = 'events';
	static const details = 'details';
	static const messages = 'messages';
}

class Field {
	static const name = 'name';
	static const totalEventCount = 'totalEventCount';
	static const subject = 'subject';
	static const date = 'date';
	static const note = 'note';
	static const content = 'content';
}
