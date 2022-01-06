import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities.dart';
import 'local.dart';

typedef Document = DocumentReference<Map<String, dynamic>>;
typedef Roles = Map<String, Role>;


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	static late Role _role;
	/// The user's [Role] in the group.
	static Role get role => _role;

	/// The [Role]s of the group's students. Updates the user's [Role].
	static Future<Roles> roles() async {
		final snapshot = await _document(Entities.students).get();
		final roles = {
			for (final studentRole in snapshot.data()!.entries)
			studentRole.key: Role.values[studentRole.value as int]
		};

		_role = roles[Local.name]!;
		return roles;
	}

	/// Adds a [Subject] with the [name] unless it exists.
	static Future<void> addSubject({required String name}) async => await _addEntity(
		entities: Entities.subjects,
		existingEquals: (existingSubject) => existingSubject == name,
		entity: name,
		details: {Field.totalEventCount.name: 0}
	);

	/// The names of the group's subjects.
	static Future<List<String>> subjectNames() async {
		final snapshot = await _document(Entities.subjects).get();
		return snapshot.exists ? (List<String>.from(snapshot.data()!.values)..sort()) : <String>[];
	}

	/// The group's [Subject]s.
	static Future<List<Subject>> subjects() async {
		final snapshots = await Future.wait([
			_document(Entities.subjects).get(),
			_document(Entities.events).get()
		]);
		final subjectNames = (snapshots.first.data() ?? {}).values;
		final eventEntries = (snapshots.last.data() ?? {});

		final subjectsEvents = {for (final subject in subjectNames) subject: <Event>[]};

		for (final event in eventEntries.values) {
			subjectsEvents[event[Field.subject.name]]!.add(Event(
				name: event[Field.name.name],
				subject: event[Field.subject.name],
				date: event[Field.date.name]
			));
		}

		return [for (final subjectName in subjectNames) Subject(
			name: subjectName,
			events: subjectsEvents[subjectName]!
		)]..sort((a, b) => a.name.compareTo(b.name));
	}

	/// Adds an [Event] with the arguments unless it exists.
	static Future<void> addEvent({
		required String name,
		String? subject,
		required DateTime date,
		String? note
	}) async {
		final wasWritten = await _addEntity(
			entities: Entities.events,
			existingEquals: (existingEvent) => existingEvent[Field.name.name] == name && existingEvent[Field.subject.name] == subject,
			entity: {
				Field.name.name: name,
				if (subject != null) Field.subject.name: subject,
				Field.date.name: date,
			},
			details: note != null ? {Field.note.name: note} : null,
		);

		if (wasWritten) {
			final document = _document(Entities.subjects);

			final subjectsSnapshot = await document.get();
			final subjectId = subjectsSnapshot.data()!.entries.firstWhere(
				(subjectEntry) => subjectEntry.value == subject
			).key;

			document.collection(Entities.details.name).doc(subjectId).update({
				Field.totalEventCount.name: FieldValue.increment(1)
			});
		}
	}

	/// The group's [Event]s.
	static Future<List<Event>> events() async {
		final snapshot = await _document(Entities.events).get();
		if (!snapshot.exists) return <Event>[];

		return [for (final event in snapshot.data()!.values) Event(
			name: event[Field.name.name],
			subject: event[Field.subject.name],
			date: event[Field.date.name]
		)]..sort((a, b) => a.date.compareTo(b.date));
	}

	/// Adds a [Message] with the arguments unless it exists.
	static Future<void> addMessage({
		required String subject,
		required String content,
	}) async => await _addEntity(
		entities: Entities.messages,
		existingEquals: (existingSubject) => existingSubject == subject,
		entity: {
			Field.subject.name: subject,
			Field.date.name: DateTime.now()
		},
		details: {
			Field.content.name: content,
			Field.author.name: Local.name
		},
	);

	/// The group's [Message]s.
	static Future<List<Message>> messages() async {
		final snapshot = await _document(Entities.messages).get();
		if (!snapshot.exists) return <Message>[];

		return [for (final message in snapshot.data()!.values) Message(
			subject: message[Field.subject.name],
			date: message[Field.date.name]
		)]..sort((a, b) => b.date.compareTo(a.date));
	}

	/// Adds the [entity] unless it exists, with the given [details] unless they are `null`.
	/// Returns whether the [entity] was written.
	static Future<bool> _addEntity({
		required Entities entities,
		required bool Function(dynamic existingEntity) existingEquals,
		required Object entity,
		Map<String, Object>? details
	}) async {
		final document = _document(entities);

		final id = await _cloud.runTransaction((transaction) async {
			final entitiesSnapshot = await transaction.get(document);
			int intId = 0;

			if (entitiesSnapshot.exists) {
				final entityEntries = entitiesSnapshot.data()!;

				for (final existingEntity in entityEntries.values) {
					if (existingEquals(existingEntity)) return null;
				}

				final takenIds = entityEntries.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final entityEntry = {id: entity};

			if (entitiesSnapshot.exists) {
				transaction.update(document, entityEntry);
			}
			else {
				transaction.set(document, entityEntry);
			}

			return id;
		});

		final wasWritten = id != null;
		if (details != null && wasWritten) document.collection(Entities.details.name).doc(id).set(details);
		return wasWritten;
	}

	/// [DocumentReference] to the document with the group's [entities].
	static Document _document(Entities entities) => _cloud.collection(entities.name).doc(Local.groupId);
}


/// The [Entities]s used in [FirebaseFirestore].
enum Entities {
	students,
	subjects,
	events,
	details,
	messages
}

/// The [Field]s used in [FirebaseFirestore].
enum Field {
	name,
	totalEventCount,
	subject,
	date,
	note,
	content,
	author
}
