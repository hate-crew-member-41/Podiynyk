import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:podiynyk/storage/entities/identification_option.dart';

import 'local.dart';
import 'fields.dart';

import 'entities/county.dart';
import 'entities/department.dart';
import 'entities/event.dart';
import 'entities/message.dart';
import 'entities/question.dart';
import 'entities/student.dart';
import 'entities/subject.dart';
import 'entities/university.dart';


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

extension on Collection {
	/// [DocumentReference] to the document with the group's data of [collection] type.
	DocumentReference<Map<String, dynamic>> get ref =>	
		FirebaseFirestore.instance.collection(name).doc(Local.groupId);
	
	/// [DocumentReference] to the details of the entity with the [id] in the group's data of [collection] type.
	DocumentReference<Map<String, dynamic>> detailsRef(String id) =>	
		ref.collection(Collection.details.name).doc(id);
}


extension on Map<String, dynamic> {
	int get newId {
		int id = 0;
		while (containsKey(id.toString())) id++;
		return id;
	}
}

extension Subjects on List<Subject> {
	List<Event> get events => [for (final subject in this) ...subject.events];
}

extension on List<Event> {
	void sortByDate() => sort((a, b) => a.date.compareTo(b.date));
}


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	/// Initializes [Firebase] and synchronizes the user's [Role] in the group.
	static Future<void> init() async {
		await Firebase.initializeApp();
	}

	/// The [County]s of Ukraine.
	static Future<List<County>> get counties => _identificationOptions(
		collection: Collection.counties,
		document: Collection.counties.name,
		optionConstructor: ({required id, required name}) => County(id: id, name: name)
	);

	/// The [Univesity]s of the [county].
	static Future<List<University>> universities(County county) => _identificationOptions(
		collection: Collection.counties,
		document: county.id,
		optionConstructor: ({required id, required name}) => University(id: id, name: name)
	);

	/// The [Department]s of the [university].
	static Future<List<Department>> departments(University university) => _identificationOptions(
		collection: Collection.universities,
		document: university.id,
		optionConstructor: ({required id, required name}) => Department(id: id, name: name)
	);

	static Future<List<O>> _identificationOptions<O extends IdentificationOption>({
		required Collection collection,
		required String document,
		required O Function({required String id, required String name}) optionConstructor
	}) async {
		final snapshot = await _cloud.collection(collection.name).doc(document).get();
		return [
			for (final entry in snapshot.data()!.entries) optionConstructor(
				id: entry.key,
				name: entry.value,
			)
		]..sort((a, b) => a.name.compareTo(b.name));
	}

	/// Adds the user to the group. If they are the group's first student, initializes the group's documents.
	static Future<void> enterGroup() async {
		final document = Collection.groups.ref;

		Local.id = await _cloud.runTransaction((transaction) async {
			final snapshot = await transaction.get(document);
			late int intId;
			late String id;

			if (snapshot.exists) {
				final data = snapshot.data()!;
				intId = data.newId;
				id = intId.toString();

				final selfInitField = data.containsKey(Field.roles.name) ? Field.roles : Field.confirmationCounts;
				transaction.update(document, {
					'${Field.names.name}.$id': Local.name,
					'${selfInitField.name}.$id': 0
				});
			}
			else {
				intId = 0;
				id = intId.toString();

				// the [set] method does not support nested fields via dot notation
				transaction.set(document, {
					Field.names.name: {id: Local.name},
					Field.confirmationCounts.name: {id: 0},
					Field.joined.name: DateTime.now()
				});

				Collection.subjects.ref.set({});
				Collection.events.ref.set({});
				Collection.messages.ref.set({});
				Collection.questions.ref.set({});
				Collection.questions.ref.set({});
			}

			return id;
		});
	}

	/// Whether the group is past the [LeaderElection] step. Updates [role].
	static Future<bool> get leaderIsElected async {
		final snapshot = await Collection.groups.ref.get();
		final data = snapshot.data()!;

		final isElected = data.containsKey(Field.roles.name);
		if (isElected) {
			final roleIndex = data[Field.roles.name][Local.id];
			_role = Role.values[roleIndex];
		}

		return isElected;
	}

	// todo: create a Firestore cloud function to change the document asa there are enough confirmations,
	// todo: make the function init the group's documents instead of [enterGroup]
	/// A [Stream] of updates of the group's [Student]s and confirmations for them to be the group's leader.
	/// As soon as the leader is determined, `null` is returned.
	static Stream<List<Student>?> get leaderElectionUpdates {
		return Collection.groups.ref.snapshots().map((snapshot) {
			final data = snapshot.data()!;

			if (data.containsKey(Field.confirmationCounts.name)) return [
				for (final entry in data[Field.names.name].entries) Student(
					id: entry.key,
					name: entry.value,
					confirmationCount: data[Field.confirmationCounts.name][entry.key]
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
		await Collection.groups.ref.update({
			'${Field.confirmationCounts.name}.$toId': FieldValue.increment(1),
			if (fromId != null) '${Field.confirmationCounts.name}.$fromId': FieldValue.increment(-1)
		});
	}

	static late Role _role;
	/// The user's [Role]. Requires [syncRole] to have been called.
	static Role get role => _role;

	/// Synchronizes the user's [Role].
	static Future<void> syncRole() async {
		final snapshot = await Collection.groups.ref.get();
		final roleIndex = snapshot.data()![Field.roles.name][Local.id];
		_role = Role.values[roleIndex];
	}

	/// The group's sorted [Subject]s with the sorted [Event]s, without the details.
	static Future<List<Subject>> get subjects async {
		final subjects = await _subjects;
		for (final subject in subjects) subject.events.sortByDate();
		return subjects..sort((a, b) => a.name.compareTo(b.name));
	}

	// tofix: no-subject events are not included
	/// The group's sorted [Event]s without the details, that the user has not hidden.
	static Future<List<Event>> get events async {
		final subjects = await _subjects;
		return subjects.events
			..removeWhere((event) => Local.entityIsStored(DataBox.hiddenEvents, event))
			..sort((a, b) => a.date.compareTo(b.date));
	}

	/// The group's [Subject]s with the unsorted [Event]s, without the details.
	static Future<List<Subject>> get _subjects async {
		final snapshots = await Future.wait([
			Collection.subjects.ref.get(),
			Collection.events.ref.get()
		]);
		final rawSubjects = snapshots.first.data()!;
		final rawEvents = snapshots.last.data()!;

		final subjects = [
			for (final entry in rawSubjects.entries) Subject(
				id: entry.key,
				name: entry.value[Field.name.name] as String,
				events: <Event>[]
			)
		];
		final subjectsById = {
			for (final subject in subjects) subject.id: subject
		};

		for (final entry in rawEvents.entries) {
			final subjectId = entry.value[Field.subject.name];
			if (subjectId == null) continue;

			final subject = subjectsById[subjectId]!;
			subject.events.add(Event(
				id: entry.key,
				name: entry.value[Field.name.name] as String,
				subject: subject,
				date: (entry.value[Field.date.name] as Timestamp).toDate(),
			));
		}

		return subjects;
	}

	/// The group's sorted non-subject [Event]s.
	static Future<List<Event>> get nonSubjectEvents async {
		final snapshot = await Collection.events.ref.get();
		final subjectEntries = snapshot.data()!.entries.where((entry) =>
			entry.value[Field.subject.name] == null
		);

		return [
			for (final entry in subjectEntries) Event(
				id: entry.key,
				name: entry.value[Field.name.name] as String,
				date: (entry.value[Field.date.name] as Timestamp).toDate(),
			)
		]..sortByDate();
	}

	/// The group's [Message]s without the details.
	static Future<List<Message>> get messages async {
		final snapshot = await Collection.messages.ref.get();

		final messages = [
			for (final entry in snapshot.data()!.entries) Message(
				id: entry.key,
				subject: entry.value[Field.subject.name] as String,
				date: (entry.value[Field.date.name] as Timestamp).toDate()
			)
		];

		// todo: what is this line?
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
		final snapshot = await Collection.groups.ref.get();
		final data = snapshot.data()!;

		final students = [
			for (final entry in data[Field.names.name].entries) Student(
				id: entry.key,
				name: entry.value,
				role: Role.values[data[Field.roles.name][entry.key]]
			)
		]..sort((a, b) => a.name.compareTo(b.name));

		_role = students.firstWhere((student) => student.name == Local.name).role!;
		return students;
	}

	/// Initializes the [subject]'s detail fields.
	static Future<void> addSubjectDetails(Subject subject) async {
		final snapshot = await Collection.subjects.detailsRef(subject.id).get();
		final details = snapshot.data()!;

		subject.totalEventCount = details[Field.totalEventCount.name];
		final info = details[Field.info.name];
		subject.info = info != null ? List<String>.from(info) : <String>[];
	}

	/// Initializes the [event]'s detail fields.
	static Future<void> addEventDetails(Event event) async {
		final snapshot = await Collection.events.detailsRef(event.id).get();
		if (!snapshot.exists) return;

		event.note = snapshot[Field.note.name];
	}

	/// Initializes the [message]'s detail fields.
	static Future<void> addMessageDetails(Message message) async {
		final snapshot = await Collection.messages.detailsRef(message.id).get();
		
		message.content = snapshot[Field.content.name];
		message.author = snapshot[Field.author.name];
	}

	/// Adds a [Subject] with the [name] unless it exists.
	static Future<void> addSubject({required String name}) async => await _addEntity(
		collection: Collection.subjects,
		existingEquals: (existingSubject) => existingSubject == name,
		entity: {Field.name.name: name},
		details: {
			Field.totalEventCount.name: 0,
			Field.info.name: <String>[]
		}
	);

	/// Updates the [info] in the [subject]'s details.
	static Future<void> updateSubjectInfo(Subject subject) async {
		Collection.subjects.detailsRef(subject.id).update({
			Field.info.name: subject.info
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
				existingEvent[Field.name.name] == name && existingEvent[Field.subject.name] == subject?.id,
			entity: {
				Field.name.name: name,
				if (subject != null) Field.subject.name: subject.id,
				Field.date.name: date,
			},
			details: {if (note != null) Field.note.name: note},
		);

		if (subject != null && wasWritten) {
			Collection.subjects.detailsRef(subject.id).update({
				Field.totalEventCount.name: FieldValue.increment(1)
			});
		}
	}

	/// Updates the [note] in the [event]'s details.
	static Future<void> updateEventNote(Event event) async {
		await Collection.events.detailsRef(event.id).update({
			Field.note.name: event.note
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
			Field.subject.name: subject,
			Field.date.name: DateTime.now()
		},
		details: {
			Field.content.name: content,
			Field.author.name: Local.name
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
		final document = collection.ref;

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
		if (details != null && wasWritten) await collection.detailsRef(id).set(details);
		return wasWritten;
	}

	// todo: should the events be deleted?
	/// Deletes the [subject]. The [subject]'s events are kept.
	static Future<void> deleteSubject(Subject subject) async {
		await Future.wait([
			Collection.subjects.ref.update({subject.id: FieldValue.delete()}),
			Collection.subjects.detailsRef(subject.id).delete()
		]);
	}

	/// Deletes the [event].
	static Future<void> deleteEvent(Event event) async {
		await Future.wait([
			Collection.events.ref.update({event.id: FieldValue.delete()}),
			Collection.events.detailsRef(event.id).delete()
		]);
	}

	/// Deletes the [message].
	static Future<void> deleteMessage(Message message) async {
		await Future.wait([
			Collection.messages.ref.update({message.id: FieldValue.delete()}),
			Collection.messages.detailsRef(message.id).delete()
		]);
	}

	/// Sets the [student]'s [Role] to [role].
	static Future<void> setRole(Student student, Role role) async {
		await Collection.groups.ref.update({
			Field.roles.name: {student.id: role.index}
		});
	}

	/// Sets the [Role] of the [student] to [Role.leader], and the user's role to [Role.trusted].
	static Future<void> makeLeader(Student student) async {
		final document = Collection.groups.ref;

		await document.update({
			Local.id: Role.trusted.index,
			student.id: Role.leader.index
		});
	}
}
