import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'fields.dart';
import 'local.dart';

import 'entities/creatable.dart';
import 'entities/event.dart';
import 'entities/message.dart';
import 'entities/question.dart';
import 'entities/student.dart';
import 'entities/subject.dart';


typedef CloudMap = Map<String, dynamic>;


/// An [Entity] [Collection] stored in [FirebaseFirestore].
enum Collection {
	groups,
	subjects,
	events,
	messages,
	details
}

extension on Collection {
	/// [DocumentReference] to the document with the group's data of [this] type.
	DocumentReference<CloudMap> get ref =>	
		FirebaseFirestore.instance.collection(name).doc(Local.groupId);

	/// [DocumentReference] to the details of the entity with the [id] in the group's data of [this] type.
	DocumentReference<CloudMap> detailsRef(String id) =>	
		ref.collection(Collection.details.name).doc(id);
}


extension CloudId on String {
	/// The string converted to be usable as a document id or a field name in [FirebaseFirestore].
	String get safeId => replaceAll('.', '').replaceAll('/', '');
}


class Cloud {
	static final _cloud = FirebaseFirestore.instance;

	/// Initializes [Firebase] and synchronizes the user's [Role] in the group.
	static Future<void> init() async {
		await Firebase.initializeApp();
	}

	/// Initializes a new group and returns its id.
	static Future<String> initGroup() async {
		final document = await _cloud.collection(Collection.groups.name).add({
			Field.students.name: <String, CloudMap>{},
			Field.joined.name: DateTime.now()
		});
		Local.groupId = document.id;

		await Future.wait([
			Collection.events.ref.set(<String, CloudMap>{}),
			Collection.subjects.ref.set(<String, CloudMap>{}),
			Collection.messages.ref.set(<String, CloudMap>{})
		]);

		return Local.groupId!;
	}

	/// Whether aa group with the [id] exists.
	static Future<bool> groupExists(String id) async {
		final snapshot = await _cloud.collection(Collection.groups.name).doc(id).get();
		return snapshot.exists;
	}

	static Future<void> enterGroup() async {
		final userField = '${Field.students.name}.${Local.userId}';

		await Collection.groups.ref.update({
			'$userField.${Field.name.name}': Local.userName,
			if (await leaderIsElected)
				'$userField.${Field.role.name}': Role.ordinary.index
			else 
				'$userField.${Field.confirmationCount.name}': 0
		});
	}

	/// Whether the group is past the [LeaderElection] step. Initializes [userRole].
	static Future<bool> get leaderIsElected async {
		final snapshot = await Collection.groups.ref.get();
		final students = snapshot[Field.students.name];

		final isElected = _leaderIsElected(students);
		if (isElected) {
			Local.leaderIsElected = true;
			_updateUserRole(students);
		}

		return isElected;
	}

	/// A [Stream] of updates of the group's [Student]s and confirmations for them to be the group's leader.
	/// Initializes [userRole] and returns `null` as soon as the leader is determined.
	static Stream<List<Student>?> get leaderElectionUpdates {
		return Collection.groups.ref.snapshots().map((snapshot) {
			final students = snapshot[Field.students.name];

			if (!_leaderIsElected(students)) return [
				for (final entry in students.entries) Student.candidateFromCloudFormat(entry)
			]..sort();

			_updateUserRole(students);
			return null;
		});
	}

	static bool _leaderIsElected(CloudMap students) => 
		students.isNotEmpty && students.values.first.containsKey(Field.role.name);

	/// Adds a confirmation for the student with the id [toId].
	/// Takes one from the student with the id [fromId] if it is not `null`.
	static Future<void> changeLeaderVote({
		required String toId,
		String? fromId
	}) async {
		final studentsField = Field.students.name, confirmationCountField = Field.confirmationCount.name;
		await Collection.groups.ref.update({
			'$studentsField.$toId.$confirmationCountField': FieldValue.increment(1),
			if (fromId != null) '$studentsField.$fromId.$confirmationCountField': FieldValue.increment(-1)
		});
	}

	static late Role _userRole;
	/// The user's [Role].
	static Role get userRole => _userRole;

	static Future<void> initRole() async {
		final snapshot = await Collection.groups.ref.get();
		_updateUserRole(snapshot[Field.students.name]);
	}

	static void _updateUserRole(CloudMap students) {
		final index = students[Local.userId][Field.role.name] as int;
		_userRole = Role.values[index];
	}

	/// The group's sorted [Event]s without the details.
	static Future<List<Event>> get events async {
		final snapshot = await Collection.events.ref.get();

		final events = [
			for (final entry in snapshot.data()!.entries) Event.fromCloudFormat(entry)
		]..sort();
		Local.clearStoredEntities(Field.hiddenEvents, events);
		Local.clearEntityLabels(Field.events, events);

		return events;
	}

	/// The group's sorted non-subject [Event]s without the details.
	static Future<List<Event>> get nonSubjectEvents async {
		final snapshot = await Collection.events.ref.get();
		final eventEntries = snapshot.data()!.entries.where((entry) =>
			entry.value[Field.subject.name] == null
		);

		return [
			for (final entry in eventEntries) Event.fromCloudFormat(entry)
		]..sort();
	}

	/// The group's sorted [Subject]s without the details, with the [Event]s.
	static Future<List<Subject>> get subjectsWithEvents async {
		final snapshots = await Future.wait([
			Collection.subjects.ref.get(),
			Collection.events.ref.get()
		]);

		final events = [
			for (final entry in snapshots.last.data()!.entries) Event.fromCloudFormat(entry)
		]..sort();

		final subjects = [
			for (final entry in snapshots.first.data()!.entries) Subject.fromCloudFormat(
				entry,
				events: events.where((event) =>
					event.subject?.name == entry.value[Field.name.name]
				).toList()
			)
		]..sort();
		Local.clearStoredEntities(Field.unfollowedSubjects, subjects);
		Local.clearEntityLabels(Field.subjects, subjects);

		return subjects;
	}

	/// The the group's sorted [Subject]s without the details.
	static Future<List<Subject>> get subjects async {
		final snapshot = await Collection.subjects.ref.get();
		return [
			for (final entry in snapshot.data()!.entries) Subject.fromCloudFormat(entry)
		]..sort();
	}

	/// The group's [Message]s without the details.
	static Future<List<Message>> get messages async {
		final snapshot = await Collection.messages.ref.get();
		return [
			for (final entry in snapshot.data()!.entries) Message.fromCloudFormat(entry)
		]..sort();
	}

	/// The group's [Question]s without the details.
	static Future<List<Question>> get questions async {
		return [];
	}

	/// The group's [Student]s. Updates [userRole].
	static Future<List<Student>> get students async {
		final snapshot = await Collection.groups.ref.get();
		final data = snapshot.data()!;

		final students = [
			for (final entry in data[Field.students.name].entries) Student.fromCloudFormat(entry)
		]..sort();
		Local.clearEntityLabels(Field.students, students);

		_userRole = students.firstWhere((student) => student.nameRepr == Local.userName).role;
		return students;
	}

	/// The details of the [collection] entity with the [id].
	static Future<CloudMap> entityDetails(Collection collection, String id) async {
		final snapshot = await collection.detailsRef(id).get();
		return snapshot.data()!;
	}

	/// Adds the [event].
	static Future<void> addEvent(Event event) => _addEntity(Collection.events, event);

	/// Adds the [subject].
	static Future<void> addSubject(Subject subject) => _addEntity(Collection.subjects, subject);

	/// Adds the [message].
	static Future<void> addMessage(Message message) => _addEntity(Collection.messages, message);

	/// Adds the [collection] [entity].
	static Future<void> _addEntity(Collection collection, CreatableEntity entity) async {
		final id = entity.id;
		await Future.wait([
			collection.ref.update({id: entity.inCloudFormat}),
			collection.detailsRef(id).set(entity.detailsInCloudFormat)
		]);
	}

	/// Updates the [event]'s date.
	static Future<void> updateEventDate(Event event) async {
		await Collection.events.ref.update({
			'${event.id}.${Field.date.name}': event.date
		});
	}

	/// Updates the [event]'s note.
	static Future<void> updateEventNote(Event event) async {
		await Collection.events.detailsRef(event.id).update({
			Field.note.name: event.note ?? FieldValue.delete()
		});
	}

	/// Adds the [subject]'s [info].
	static Future<void> updateSubjectInfo(Subject subject, SubjectInfo info) async {
		Collection.subjects.detailsRef(subject.id).update({
			'${Field.info.name}.${info.id}': info.inCloudFormat
		});
	}

	/// Deletes the [subject]'s [info].
	static Future<void> deleteSubjectInfo(Subject subject, SubjectInfo info) async {
		Collection.subjects.detailsRef(subject.id).update({
			'${Field.info.name}.${info.id}': FieldValue.delete()
		});
	}

	/// Updates the [message]'s name (topic).
	static Future<void> updateMessageName(Message message) async {
		await Collection.messages.ref.update({
			'${message.id}.${Field.name.name}': message.name
		});
	}

	/// Updates the [message]'s content.
	static Future<void> updateMessageContent(Message message) async {
		await Collection.messages.detailsRef(message.id).update({
			Field.content.name: message.content
		});
	}

	/// Sets the [student]'s [Role] to [userRole].
	static Future<void> updateRole(Student student) async {
		await Collection.groups.ref.update({
			'${Field.students.name}.${student.id}.${Field.role.name}': student.role.index
		});
	}

	/// Sets the the [student]'s [Role] to [Role.leader], and the user's role to [Role.trusted].
	static Future<void> makeLeader(Student student) async {
		final studentsField = Field.students.name, roleField = Field.role.name;
		await Collection.groups.ref.update({
			'$studentsField.${Local.userId}.$roleField': Role.trusted.index,
			'$studentsField.${student.id}.$roleField': Role.leader.index
		});
		_userRole = Role.trusted;
	}

	/// Updates the user's name.
	static Future<void> updateName() async {
		await Collection.groups.ref.update({
			'${Field.students.name}.${Local.userId}.${Field.name.name}': Local.userName
		});
	}

	/// Deletes the [event].
	static Future<void> deleteEvent(Event event) async {
		await Future.wait([
			Collection.events.ref.update({event.id: FieldValue.delete()}),
			Collection.events.detailsRef(event.id).delete()
		]);
	}

	/// Deletes the [subject] and its [Event]s.
	static Future<void> deleteSubject(Subject subject) async {
		await Future.wait([
			Collection.subjects.ref.update({subject.id: FieldValue.delete()}),
			Collection.subjects.detailsRef(subject.id).delete(),
			Collection.events.ref.update({
				for (final event in subject.events!) event.id: FieldValue.delete()
			})
		]);
	}

	/// Deletes the [message].
	static Future<void> deleteMessage(Message message) async {
		await Future.wait([
			Collection.messages.ref.update({message.id: FieldValue.delete()}),
			Collection.messages.detailsRef(message.id).delete()
		]);
	}
}
