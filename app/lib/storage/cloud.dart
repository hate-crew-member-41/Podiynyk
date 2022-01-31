import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:podiynyk/storage/entities/identification_option.dart';

import 'local.dart';
import 'entities/county.dart';
import 'entities/department.dart';
import 'entities/event.dart';
import 'entities/message.dart';
import 'entities/question.dart';
import 'entities/student.dart';
import 'entities/subject.dart';
import 'entities/university.dart';


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	/// Initializes [Firebase] and synchronizes the user's [Role] in the group.
	static Future<void> init() async {
		await Firebase.initializeApp();
	}

	/// The [County]s of Ukraine.
	static Future<List<County>> counties() => _identificationOptions(
		entities: Entities.counties,
		document: Entities.counties.name,
		optionConstructor: ({required id, required name}) => County(id: id, name: name)
	);

	/// The [Univesity]s of the [county].
	static Future<List<University>> universities(County county) => _identificationOptions(
		entities: Entities.counties,
		document: county.id,
		optionConstructor: ({required id, required name}) => University(id: id, name: name)
	);

	/// The [Department]s of the [university].
	static Future<List<Department>> departments(University university) => _identificationOptions(
		entities: Entities.universities,
		document: university.id,
		optionConstructor: ({required id, required name}) => Department(id: id, name: name)
	);

	static Future<List<O>> _identificationOptions<O extends IdentificationOption>({
		required Entities entities,
		required String document,
		required O Function({required String id, required String name}) optionConstructor
	}) async {
		final snapshot = await _cloud.collection(entities.name).doc(document).get();
		return [
			for (final entry in snapshot.data()!.entries) optionConstructor(
				id: entry.key,
				name: entry.value,
			)
		]..sort((a, b) => a.name.compareTo(b.name));
	}

	static late Role _role;
	/// The user's [Role].
	static Role get role => _role;

	/// Synchronizes the user's [Role].
	static Future<void> _syncRole() async {
		final snapshot = await _groupDocument(Entities.students).get();
		final students = snapshot.data()!;

		if (students[Role.ordinary.name].contains(Local.name)) {
			_role = Role.ordinary;
		}
		else if (students[Role.trusted.name].contains(Local.name)) {
			_role = Role.trusted;
		}
		else {
			_role = Role.leader;
		}
	}

	/// The names of the group's subjects.
	static Future<List<String>> subjectNames() async {
		final snapshot = await _groupDocument(Entities.subjects).get();
		return snapshot.exists ? (List<String>.from(snapshot.data()!.values)..sort()) : <String>[];
	}

	/// The group's [Subject]s without the details.
	static Future<List<Subject>> subjects() async {
		final snapshots = await Future.wait([
			_groupDocument(Entities.subjects).get(),
			_groupDocument(Entities.events).get()
		]);
		final entries = (snapshots.first.data() ?? {});
		final eventEntries = (snapshots.last.data() ?? {});

		final events = {for (final name in entries.values) name: <Event>[]};

		for (final entry in eventEntries.entries.where(
			(entry) => entry.value.containsKey(_Field.subject.name)
		)) {
			events[entry.value[_Field.subject.name]]!.add(Event(
				id: entry.key,
				name: entry.value[_Field.name.name],
				subject: entry.value[_Field.subject.name],
				date: entry.value[_Field.date.name].toDate()
			));
		}

		for (final events in events.values) events.sort((a, b) => a.date.compareTo(b.date));

		return [for (final entry in entries.entries) Subject(
			id: entry.key,
			name: entry.value,
			events: events[entry.value]!
		)]..sort((a, b) => a.name.compareTo(b.name));
	}

	/// The group's [Event]s without the details.
	static Future<List<Event>> events() async {
		final snapshot = await _groupDocument(Entities.events).get();
		if (!snapshot.exists) return <Event>[];

		final events = [
			for (final entry in snapshot.data()!.entries) Event(
				id: entry.key,
				name: entry.value[_Field.name.name],
				subject: entry.value[_Field.subject.name],
				date: entry.value[_Field.date.name].toDate()
			)
		];
		Local.clearStoredEntities<Event, EventEssence>(Stored.hiddenEvents, events);

		return events
			..removeWhere((event) => Local.entityIsStored(Stored.hiddenEvents, event))
			..sort((a, b) => a.date.compareTo(b.date));
	}

	/// The group's [Message]s without the details.
	static Future<List<Message>> messages() async {
		final snapshot = await _groupDocument(Entities.messages).get();
		if (!snapshot.exists) return <Message>[];

		final messages = [
			for (final entry in snapshot.data()!.entries) Message(
				id: entry.key,
				subject: entry.value[_Field.subject.name],
				date: entry.value[_Field.date.name].toDate()
			)
		];
		Local.clearStoredEntities<Message, MessageEssence>(Stored.hiddenMessages, messages);

		return messages
			..removeWhere((message) => Local.entityIsStored(Stored.hiddenMessages, message))
			..sort((a, b) => b.date.compareTo(a.date));
	}

	// todo: define
	/// The group's [Question]s without the details.
	static Future<List<Question>> questions() async {
		return [];
	}

	/// The group's [Student]s. Updates the user's [Role].
	static Future<List<Student>> students() async {
		final snapshot = await _groupDocument(Entities.students).get();
		final entries = snapshot.data()!;

		final students = [
			for (final name in entries[Role.ordinary.name]) Student(
				name: name,
				role: Role.ordinary
			),
			for (final name in entries[Role.trusted.name]) Student(
				name: name,
				role: Role.trusted
			),
			Student(
				name: entries[Role.leader.name],
				role: Role.leader
			)
		]..sort((a, b) => a.name.compareTo(b.name));

		_role = students.firstWhere((student) => student.name == Local.name).role;
		return students;
	}

	/// Initializes the [subject]'s detail fields.
	static Future<void> addSubjectDetails(Subject subject) async {
		final snapshot = await _groupDocument(Entities.subjects).collection(Entities.details.name).doc(subject.id).get();
		final details = snapshot.data()!;

		subject.totalEventCount = details[_Field.totalEventCount.name];
		subject.info = List<String>.from(details[_Field.info.name]);
	}

	/// Initializes the [event]'s detail fields.
	static Future<void> addEventDetails(Event event) async {
		final snapshot = await _groupDocument(Entities.events).collection(Entities.details.name).doc(event.id).get();
		if (!snapshot.exists) return;

		event.note = snapshot[_Field.note.name];
	}

	/// Initializes the [message]'s detail fields.
	static Future<void> addMessageDetails(Message message) async {
		final snapshot = await _groupDocument(Entities.messages).collection(Entities.details.name).doc(message.id).get();
		
		message.content = snapshot[_Field.content.name];
		message.author = snapshot[_Field.author.name];
	}

	/// Adds a [Subject] with the [name] unless it exists.
	static Future<void> addSubject({required String name}) async => await _addEntity(
		entities: Entities.subjects,
		existingEquals: (existingSubject) => existingSubject == name,
		entity: name,
		details: {_Field.totalEventCount.name: 0}
	);

	/// Updates the [info] in the [subject]'s details.
	static Future<void> updateSubjectInfo(Subject subject) async {
		_groupDocument(Entities.subjects).collection(Entities.details.name).doc(subject.id).update({
			_Field.info.name: subject.info
		});
	}

	/// Adds an [Event] with the arguments unless it exists. Increments the [subject]'s total event count.
	static Future<void> addEvent({
		required String name,
		String? subject,
		required DateTime date,
		String? note
	}) async {
		final wasWritten = await _addEntity(
			entities: Entities.events,
			existingEquals: (existingEvent) =>
				existingEvent[_Field.name.name] == name && existingEvent[_Field.subject.name] == subject,
			entity: {
				_Field.name.name: name,
				if (subject != null) _Field.subject.name: subject,
				_Field.date.name: date,
			},
			details: {if (note != null) _Field.note.name: note},
		);

		if (subject != null && wasWritten) {
			final document = _groupDocument(Entities.subjects);

			final subjectsSnapshot = await document.get();
			final subjectId = subjectsSnapshot.data()!.entries.firstWhere(
				(subjectEntry) => subjectEntry.value == subject
			).key;

			document.collection(Entities.details.name).doc(subjectId).update({
				_Field.totalEventCount.name: FieldValue.increment(1)
			});
		}
	}

	/// Updates the [note] in the [event]'s details.
	static Future<void> updateEventNote(Event event) async {
		await _groupDocument(Entities.events).collection(Entities.details.name).doc(event.id).update({
			_Field.note.name: event.note
		});
	}

	/// Adds a [Message] with the arguments unless it exists.
	static Future<void> addMessage({
		required String subject,
		required String content,
	}) async => await _addEntity(
		entities: Entities.messages,
		existingEquals: (existingSubject) => existingSubject == subject,
		entity: {
			_Field.subject.name: subject,
			_Field.date.name: DateTime.now()
		},
		details: {
			_Field.content.name: content,
			_Field.author.name: Local.name
		},
	);

	// todo: define
	/// Adds a [Question] with the arguments unless it exists.
	static Future<void> addQuestion() async {}

	/// Adds the [entity] unless it exists, with the given [details] unless they are `null`.
	/// Returns whether the [entity] was written.
	static Future<bool> _addEntity({
		required Entities entities,
		required bool Function(dynamic existingEntity) existingEquals,
		required Object entity,
		Map<String, Object>? details
	}) async {
		final document = _groupDocument(entities);

		final id = await _cloud.runTransaction((transaction) async {
			final snapshot = await transaction.get(document);
			int intId = 0;

			if (snapshot.exists) {
				final entries = snapshot.data()!;

				for (final existingEntity in entries.values) {
					if (existingEquals(existingEntity)) return null;
				}

				final takenIds = entries.keys;
				while (takenIds.contains(intId.toString())) intId++;
			}

			final id = intId.toString();
			final entityEntry = {id: entity};

			if (snapshot.exists) {
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

	// todo: should the events be deleted?
	/// Deletes the [subject]. The [subject]'s events are kept.
	static Future<void> deleteSubject(Subject subject) async {
		final document = _groupDocument(Entities.subjects);
		await Future.wait([
			document.update({subject.id: FieldValue.delete()}),
			document.collection(Entities.details.name).doc(subject.id).delete()
		]);
	}

	/// Deletes the [event].
	static Future<void> deleteEvent(Event event) async {
		final document = _groupDocument(Entities.events);
		await Future.wait([
			document.update({event.id: FieldValue.delete()}),
			document.collection(Entities.details.name).doc(event.id).delete()
		]);
	}

	/// Deletes the [message].
	static Future<void> deleteMessage(Message message) async {
		final document = _groupDocument(Entities.messages);
		await Future.wait([
			document.update({message.id: FieldValue.delete()}),
			document.collection(Entities.details.name).doc(message.id).delete()
		]);
	}

	/// Sets the [Role] of the student with the [name] to [Role.trusted].
	static Future<void> makeTrusted(String name) async {
		await _groupDocument(Entities.students).update({
			Role.ordinary.name: FieldValue.arrayRemove([name]),
			Role.trusted.name: FieldValue.arrayUnion([name])
		});
	}

	/// Sets the [Role] of the student with the [name] to [Role.ordinary].
	static Future<void> makeOrdinary(String name) async {
		await _groupDocument(Entities.students).update({
			Role.trusted.name: FieldValue.arrayRemove([name]),
			Role.ordinary.name: FieldValue.arrayUnion([name])
		});
	}

	/// Sets the [Role] of the student with the [name] to [Role.leader], and the user's role to [Role.trusted].
	static Future<void> makeLeader(String name) async {
		final document = _groupDocument(Entities.students);

		final trustedSnapshot = await document.get();
		final trusted = trustedSnapshot[Role.trusted.name];
		trusted..remove(name)..add(Local.name);

		await _groupDocument(Entities.students).update({
			Role.leader.name: name,
			Role.trusted.name: trusted
		});
	}

	/// [DocumentReference] to the document with the group's [entities].
	static DocumentReference<Map<String, dynamic>> _groupDocument(Entities entities) {
		return _cloud.collection(entities.name).doc(Local.groupId);
	}
}


/// The group's [Entities] stored in [FirebaseFirestore].
enum Entities {
	counties,
	universities,
	students,
	subjects,
	events,
	details,
	messages
}

/// The [_Field]s used in [FirebaseFirestore].
enum _Field {
	name,
	totalEventCount,
	info,
	subject,
	date,
	note,
	content,
	author
}
