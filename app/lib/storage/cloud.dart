import 'dart:async';

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


extension on Map<String, dynamic> {
	int get newId {
		int id = 0;
		while (containsKey(id.toString())) id++;
		return id;
	}
}


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	/// Initializes [Firebase] and synchronizes the user's [Role] in the group.
	static Future<void> init() async {
		await Firebase.initializeApp();
	}

	/// The [County]s of Ukraine.
	static Future<List<County>> get counties => _identificationOptions(
		entities: Collection.counties,
		document: Collection.counties.name,
		optionConstructor: ({required id, required name}) => County(id: id, name: name)
	);

	/// The [Univesity]s of the [county].
	static Future<List<University>> universities(County county) => _identificationOptions(
		entities: Collection.counties,
		document: county.id,
		optionConstructor: ({required id, required name}) => University(id: id, name: name)
	);

	/// The [Department]s of the [university].
	static Future<List<Department>> departments(University university) => _identificationOptions(
		entities: Collection.universities,
		document: university.id,
		optionConstructor: ({required id, required name}) => Department(id: id, name: name)
	);

	static Future<List<O>> _identificationOptions<O extends IdentificationOption>({
		required Collection entities,
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

	/// Adds the user to the group. If they are the group's first student, initializes the group's documents.
	static Future<void> enterGroup() async {
		final document = _groupDocument(Collection.groups);

		Local.id = await _cloud.runTransaction((transaction) async {
			final snapshot = await transaction.get(document);
			late int intId;
			late String id;

			if (snapshot.exists) {
				final data = snapshot.data()!;
				intId = data.newId;
				id = intId.toString();

				final selfInitField = data.containsKey(_Field.roles.name) ? _Field.roles : _Field.confirmationCounts;
				transaction.update(document, {
					'${_Field.names.name}.$id': Local.name,
					'${selfInitField.name}.$id': 0
				});
			}
			else {
				intId = 0;
				id = intId.toString();

				// the [set] method does not support nested fields via dot notation, unlike the [update] method
				transaction.set(document, {
					_Field.names.name: {id: Local.name},
					_Field.confirmationCounts.name: {id: 0},
					_Field.joined.name: DateTime.now()
				});

				_groupDocument(Collection.subjects).set({});
				_groupDocument(Collection.events).set({});
				_groupDocument(Collection.messages).set({});
				_groupDocument(Collection.questions).set({});
				_groupDocument(Collection.questions).set({});
			}

			return id;
		});
	}

	/// Whether the group is past the [LeaderElection] step. Updates [role].
	static Future<bool> get leaderIsElected async {
		final snapshot = await _groupDocument(Collection.groups).get();
		final data = snapshot.data()!;

		final isElected = data.containsKey(_Field.roles.name);
		if (isElected) {
			final roleIndex = data[_Field.roles.name][Local.id];
			_role = Role.values[roleIndex];
		}

		return isElected;
	}

	// todo: create a Firestore cloud function to change the document asa there are enough confirmations,
	// todo: make the function init the group's documents instead of [enterGroup]
	/// A [Stream] of updates of the group's [Student]s and confirmations for them to be the group's leader.
	/// As soon as the leader is determined, `null` is returned.
	static Stream<List<Student>?> get leaderElectionUpdates {
		return _groupDocument(Collection.groups).snapshots().map((snapshot) {
			final data = snapshot.data()!;

			if (data.containsKey(_Field.confirmationCounts.name)) return [
				for (final entry in data[_Field.names.name].entries) Student(
					id: entry.key,
					name: entry.value,
					confirmationCount: data[_Field.confirmationCounts.name][entry.key]
				)
			]..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

			_role = Role.ordinary;
			return null;
		});
	}

	/// Adds a vote for the [Student] with the id [toId] and takes a vote from one with the id [fromId], if not `null`;
	static Future<void> changeLeaderVote({
		required String toId,
		String? fromId
	}) async {
		await _groupDocument(Collection.groups).update({
			'${_Field.confirmationCounts.name}.$toId': FieldValue.increment(1),
			if (fromId != null) '${_Field.confirmationCounts.name}.$fromId': FieldValue.increment(-1)
		});
	}

	static late Role _role;
	/// The user's [Role]. Requires [syncRole] to have been called.
	static Role get role => _role;

	/// Synchronizes the user's [Role].
	static Future<void> syncRole() async {
		final snapshot = await _groupDocument(Collection.groups).get();
		final roleIndex = snapshot.data()![_Field.roles.name][Local.id];
		_role = Role.values[roleIndex];
	}

	/// The group's [Subject]s without the [Event]s and details.
	static Future<List<Subject>> get subjects async {
		final snapshot = await _groupDocument(Collection.subjects).get();
		return [for (final entry in snapshot.data()!.entries) Subject(
			id: entry.key,
			name: entry.value[_Field.name.name]
		)]..sort((a, b) => a.name.compareTo(b.name));
	}

	/// The group's [Subject]s without the details.
	static Future<List<Subject>> get subjectsWithEvents async {
		final snapshots = await Future.wait([
			_groupDocument(Collection.subjects).get(),
			_groupDocument(Collection.events).get()
		]);
		final subjectEntries = snapshots.first.data()!;
		final eventEntries = snapshots.last.data()!;

		final subjects = [for (final entry in subjectEntries.entries) Subject(
			id: entry.key,
			name: entry.value[_Field.name.name],
		)]..sort((a, b) => a.name.compareTo(b.name));

		for (final subject in subjects) {
			subject.events = [
				for (final entry in eventEntries.entries.where((entry) =>
					entry.value[_Field.subject.name] == subject.id
				)) Event(
					id: entry.key,
					name: entry.value[_Field.name.name],
					subject: subject,
					date: entry.value[_Field.date.name],
				)
			]..sort((a, b) => a.date.compareTo(b.date));
		}

		return subjects;
	}

	/// The group's [Event]s without the details.
	static Future<List<Event>> get events async {
		final snapshot = await _groupDocument(Collection.events).get();
		if (!snapshot.exists) return <Event>[];

		final events = [
			for (final entry in snapshot.data()!.entries) Event(
				id: entry.key,
				name: entry.value[_Field.name.name],
				// tofix: subjects also need to be fetched to construct a Subject object here
				// however, Agenda section already fetches events and subjects,
				// so just fetching subjects here means fetching subjects twice in it
				subject: entry.value[_Field.subject.name],
				date: entry.value[_Field.date.name].toDate()
			)
		];
		Local.clearStoredEntities<Event, EventEssence>(DataBox.hiddenEvents, events);

		return events
			..removeWhere((event) => Local.entityIsStored(DataBox.hiddenEvents, event))
			..sort((a, b) => a.date.compareTo(b.date));
	}

	/// The group's [Message]s without the details.
	static Future<List<Message>> get messages async {
		final snapshot = await _groupDocument(Collection.messages).get();
		if (!snapshot.exists) return <Message>[];

		final messages = [
			for (final entry in snapshot.data()!.entries) Message(
				id: entry.key,
				subject: entry.value[_Field.subject.name],
				date: entry.value[_Field.date.name].toDate()
			)
		];
		Local.clearStoredEntities<Message, MessageEssence>(DataBox.hiddenMessages, messages);

		return messages
			..removeWhere((message) => Local.entityIsStored(DataBox.hiddenMessages, message))
			..sort((a, b) => b.date.compareTo(a.date));
	}

	// todo: define
	/// The group's [Question]s without the details.
	static Future<List<Question>> get questions async {
		return [];
	}

	/// The group's [Student]s. Updates [role].
	static Future<List<Student>> get students async {
		final snapshot = await _groupDocument(Collection.groups).get();
		final data = snapshot.data()!;

		final students = [
			for (final entry in data[_Field.names.name].entries) Student(
				id: entry.key,
				name: entry.value,
				role: Role.values[data[_Field.roles.name][entry.key]]
			)
		]..sort((a, b) => a.name.compareTo(b.name));

		_role = students.firstWhere((student) => student.name == Local.name).role!;
		return students;
	}

	/// Initializes the [subject]'s detail fields.
	static Future<void> addSubjectDetails(Subject subject) async {
		final snapshot = await _groupDocument(Collection.subjects).collection(Collection.details.name).doc(subject.id).get();
		final details = snapshot.data()!;

		subject.totalEventCount = details[_Field.totalEventCount.name];
		final info = details[_Field.info.name];
		subject.info = info != null ? List<String>.from(info) : <String>[];
	}

	/// Initializes the [event]'s detail fields.
	static Future<void> addEventDetails(Event event) async {
		final snapshot = await _groupDocument(Collection.events).collection(Collection.details.name).doc(event.id).get();
		if (!snapshot.exists) return;

		event.note = snapshot[_Field.note.name];
	}

	/// Initializes the [message]'s detail fields.
	static Future<void> addMessageDetails(Message message) async {
		final snapshot = await _groupDocument(Collection.messages).collection(Collection.details.name).doc(message.id).get();
		
		message.content = snapshot[_Field.content.name];
		message.author = snapshot[_Field.author.name];
	}

	/// Adds a [Subject] with the [name] unless it exists.
	static Future<void> addSubject({required String name}) async => await _addEntity(
		collection: Collection.subjects,
		existingEquals: (existingSubject) => existingSubject == name,
		entity: {_Field.name.name: name},
		details: {
			_Field.totalEventCount.name: 0,
			_Field.info.name: <String>[]
		}
	);

	/// Updates the [info] in the [subject]'s details.
	static Future<void> updateSubjectInfo(Subject subject) async {
		_groupDocument(Collection.subjects).collection(Collection.details.name).doc(subject.id).update({
			_Field.info.name: subject.info
		});
	}

	/// Adds an [Event] with the arguments unless it exists. Increments the [subject]'s total event count.
	static Future<void> addEvent({
		required String name,
		Subject? subject,
		required DateTime date,
		String? note
	}) async {
		final wasWritten = await _addEntity(
			collection: Collection.events,
			existingEquals: (existingEvent) =>
				existingEvent[_Field.name.name] == name && existingEvent[_Field.subject.name] == subject?.id,
			entity: {
				_Field.name.name: name,
				_Field.subject.name: subject?.id,
				_Field.date.name: date,
			},
			details: {if (note != null) _Field.note.name: note},
		);

		if (subject != null && wasWritten) {
			final document = _groupDocument(Collection.subjects);

			document.collection(Collection.details.name).doc(subject.id).update({
				_Field.totalEventCount.name: FieldValue.increment(1)
			});
		}
	}

	/// Updates the [note] in the [event]'s details.
	static Future<void> updateEventNote(Event event) async {
		await _groupDocument(Collection.events).collection(Collection.details.name).doc(event.id).update({
			_Field.note.name: event.note
		});
	}

	/// Adds a [Message] with the arguments unless it exists.
	static Future<void> addMessage({
		required String subject,
		required String content,
	}) async => await _addEntity(
		collection: Collection.messages,
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

	// todo: act as though the document always exists
	/// Adds the [entity] unless it exists, with the given [details] unless they are `null`.
	/// Returns whether the [entity] was written.
	static Future<bool> _addEntity({
		required Collection collection,
		required bool Function(dynamic existingEntity) existingEquals,
		required Object entity,
		Map<String, Object>? details
	}) async {
		final document = _groupDocument(collection);

		final id = await _cloud.runTransaction((transaction) async {
			final snapshot = await transaction.get(document);
			final entries = snapshot.data()!;

			for (final existingEntity in entries.values) {
				if (existingEquals(existingEntity)) return null;
			}

			final id = entries.newId.toString();
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
		if (details != null && wasWritten) document.collection(Collection.details.name).doc(id).set(details);
		return wasWritten;
	}

	// todo: should the events be deleted?
	/// Deletes the [subject]. The [subject]'s events are kept.
	static Future<void> deleteSubject(Subject subject) async {
		final document = _groupDocument(Collection.subjects);
		await Future.wait([
			document.update({subject.id: FieldValue.delete()}),
			document.collection(Collection.details.name).doc(subject.id).delete()
		]);
	}

	/// Deletes the [event].
	static Future<void> deleteEvent(Event event) async {
		final document = _groupDocument(Collection.events);
		await Future.wait([
			document.update({event.id: FieldValue.delete()}),
			document.collection(Collection.details.name).doc(event.id).delete()
		]);
	}

	/// Deletes the [message].
	static Future<void> deleteMessage(Message message) async {
		final document = _groupDocument(Collection.messages);
		await Future.wait([
			document.update({message.id: FieldValue.delete()}),
			document.collection(Collection.details.name).doc(message.id).delete()
		]);
	}

	/// Sets the [student]'s [Role] to [role].
	static Future<void> setRole(Student student, Role role) async {
		await _groupDocument(Collection.groups).update({
			_Field.roles.name: {student.id: role.index}
		});
	}

	/// Sets the [Role] of the [student] to [Role.leader], and the user's role to [Role.trusted].
	static Future<void> makeLeader(Student student) async {
		final document = _groupDocument(Collection.groups);

		document.update({
			Local.id: Role.trusted.index,
			student.id: Role.leader.index
		});
	}

	/// [DocumentReference] to the document with the group's data of [collection] type.
	static DocumentReference<Map<String, dynamic>> _groupDocument(Collection collection) {
		return _cloud.collection(collection.name).doc(Local.groupId);
	}
}


/// The group's [Collection] stored in [FirebaseFirestore].
enum Collection {
	counties,
	universities,
	groups,
	subjects,
	events,
	messages,
	questions,
	details
}

/// The [_Field]s used in [FirebaseFirestore].
enum _Field {
	names,
	confirmationCounts,
	roles,
	joined,
	name,
	totalEventCount,
	info,
	subject,
	date,
	note,
	content,
	author
}
