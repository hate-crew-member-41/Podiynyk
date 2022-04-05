import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'identifiers.dart';
import 'local.dart';

import 'entities/entity.dart';
import 'entities/event.dart';
import 'entities/message.dart';
import 'entities/student.dart';
import 'entities/subject.dart';


typedef CloudMap = Map<String, dynamic>;


/// An [Entity] collection of the group, stored in [FirebaseFirestore].
enum Collection {
	events,
	groups,
	messages,
	students,
	subjects
}

extension EntityCollectionRefs on Collection {
	/// A reference to the document with [this].
	DocumentReference<CloudMap> get ref =>	
		FirebaseFirestore.instance.collection(name).doc(Local.groupId);

	/// A reference to the [entity]'s details.
	DocumentReference<CloudMap> detailsRef(Entity entity) =>	
		ref.collection(Identifier.details.name).doc(entity.id);
}


abstract class Cloud {
	/// Initializes [Firebase].
	static Future<void> init() async {
		await Firebase.initializeApp();
	}

	/// Creates a new group, initializes [Local.groupId] and returns it.
	static Future<String> initGroup() async {
		final document = await FirebaseFirestore.instance.collection(Collection.groups.name).add({
			Identifier.joined.name: DateTime.now()
		});
		Local.groupId = document.id;
		await Collection.students.ref.set({});

		return document.id;
	}

	/// Whether the [name] is unique in the user's group.
	static Future<bool> nameIsUnique(String name) async {
		final snapshot = await Collection.students.ref.get();
		return _nameIsUnique(snapshot.data()!, name);
	}

	/// Whether the [name] is unique in the group with the [groupId].
	/// Returns `null` if the [groupId] does not exist.
	static Future<bool?> nameIsUniqueInGroup(String groupId, String name) async {
		final snapshot = await FirebaseFirestore.instance.collection(Collection.students.name).doc(groupId).get();
		return snapshot.exists ? _nameIsUnique(snapshot.data()!, name) : null;
	}

	static bool _nameIsUnique(CloudMap students, String name) {
		final ownerObject = students.values.firstWhere(
			(object) => object[Identifier.name.name] == name,
			orElse: () => null
		);
		return ownerObject == null;
	}

	/// Adds the user to the group.
	/// Initializes the [Identifier.role] / [Identifier.confirmationCount], [Local.userRole].
	static Future<void> enterGroup() async {
		final snapshot = await Collection.students.ref.get();
		final students = snapshot.data()!;
		final leaderIsElected = students.isNotEmpty &&	
			(students.values.first as CloudMap).containsKey(Identifier.role.name);

		await Collection.students.ref.update({
			'${Local.userId}.${Identifier.name.name}': Local.userName,
			if (leaderIsElected)
				'${Local.userId}.${Identifier.role.name}': Role.ordinary.index
			else 
				'${Local.userId}.${Identifier.confirmationCount.name}': 0
		});

		if (leaderIsElected) Local.userRole = Role.ordinary;
	}

	/// Updates [Local.userRole].
	static Future<void> updateUserRole() async {
		final snapshot = await Collection.students.ref.get();
		final index = snapshot.data()![Local.userId][Identifier.role.name];
		Local.userRole = index != null ? Role.values[index] : null;
	}

	// /// A [Stream] of updates of the group's [Student]s and confirmations for them to be the group's leader.
	// /// Initializes [userRole] and returns `null` as soon as the leader is determined.
	// static Stream<List<Student>?> get leaderElectionUpdates {
	// 	return EntityCollection.groups.ref.snapshots().map((snapshot) {
	// 		final students = snapshot[Identifier.students.name];

	// 		if (!_leaderIsElected(students)) return [
	// 			for (final entry in students.entries) Student.candidateFromCloudFormat(entry)
	// 		]..sort();

	// 		_updateUserRole(students);
	// 		return null;
	// 	});
	// }

	// static bool _leaderIsElected(CloudMap students) => 
	// 	students.isNotEmpty && students.values.first.containsKey(Identifier.role.name);

	// /// Adds a confirmation for the student with the id [toId].
	// /// Takes one from the student with the id [fromId] if it is not `null`.
	// static Future<void> changeLeaderVote({
	// 	required String toId,
	// 	String? fromId
	// }) async {
	// 	final studentsField = Identifier.students.name, confirmationCountField = Identifier.confirmationCount.name;
	// 	await EntityCollection.groups.ref.update({
	// 		'$studentsField.$toId.$confirmationCountField': FieldValue.increment(1),
	// 		if (fromId != null) '$studentsField.$fromId.$confirmationCountField': FieldValue.increment(-1)
	// 	});
	// }

	/// The group's sorted [Event]s without the details.
	static Future<List<Event>> get events async {
		final snapshot = await Collection.events.ref.get();

		final events = [
			for (final entry in snapshot.data()!.entries) Event.fromCloud(id: entry.key, object: entry.value as CloudMap)
		]..sort();
		Local.deleteOutdatedEntities(Identifier.hiddenEvents, events);
		Local.clearEntityLabels(events);

		return events;
	}

	/// The group's sorted [Subject]s without the details.
	static Future<List<Subject>> get subjects async {
		final snapshot = await Collection.subjects.ref.get();

		final subjects = [
			for (final entry in snapshot.data()!.entries) Subject.fromCloud(id: entry.key, object: entry.value as CloudMap)
		]..sort();
		Local.deleteOutdatedEntities(Identifier.unfollowedSubjects, subjects);
		Local.clearEntityLabels(subjects);

		return subjects;
	}

	/// The group's sorted [Message]s without the details.
	static Future<List<Message>> get messages async {
		final snapshot = await Collection.messages.ref.get();
		return [
			for (final entry in snapshot.data()!.entries) Message.fromCloud(id: entry.key, object: entry.value as CloudMap)
		]..sort();
	}

	/// The group's sorted [Student]s. Updates [userRole].
	static Future<List<Student>> get students async {
		final snapshot = await Collection.students.ref.get();

		final students = [
			for (final entry in snapshot.data()!.entries) Student.fromCloud(id: entry.key, object: entry.value as CloudMap)
		]..sort();
		Local.clearEntityLabels(students);

		// _userRole = students.firstWhere((student) => student.id == Local.userId).role!;
		return students;
	}

	/// The [entity]'s details.
	static Future<CloudMap> entityDetails(Entity entity) async {
		final snapshot = await entity.cloudCollection!.detailsRef(entity).get();
		return snapshot.data()!;
	}

	// /// Updates the [event]'s date.
	// static Future<void> updateEventDate(Event event) async {
	// 	await EntityCollection.events.ref.update({
	// 		'${event.id}.${Identifier.date.name}': event.date
	// 	});
	// }

	// /// Updates the [event]'s note.
	// static Future<void> updateEventNote(Event event) async {
	// 	await EntityCollection.events.detailsRef(event.id).update({
	// 		Identifier.note.name: event.note ?? FieldValue.delete()
	// 	});
	// }

	// /// Adds the [subject]'s [info].
	// static Future<void> updateSubjectInfo(Subject subject, SubjectInfo info) async {
	// 	EntityCollection.subjects.detailsRef(subject.id).update({
	// 		'${Identifier.info.name}.${info.id}': info.inCloudFormat
	// 	});
	// }

	// /// Deletes the [subject]'s [info].
	// static Future<void> deleteSubjectInfo(Subject subject, SubjectInfo info) async {
	// 	EntityCollection.subjects.detailsRef(subject.id).update({
	// 		'${Identifier.info.name}.${info.id}': FieldValue.delete()
	// 	});
	// }

	// /// Updates the [message]'s name (topic).
	// static Future<void> updateMessageName(Message message) async {
	// 	await EntityCollection.messages.ref.update({
	// 		'${message.id}.${Identifier.name.name}': message.name
	// 	});
	// }

	// /// Updates the [message]'s content.
	// static Future<void> updateMessageContent(Message message) async {
	// 	await EntityCollection.messages.detailsRef(message.id).update({
	// 		Identifier.content.name: message.content
	// 	});
	// }

	// /// Sets the [student]'s [Role] to [userRole].
	// static Future<void> updateRole(Student student) async {
	// 	await EntityCollection.groups.ref.update({
	// 		'${Identifier.students.name}.${student.id}.${Identifier.role.name}': student.role.index
	// 	});
	// }

	// /// Sets the the [student]'s [Role] to [Role.leader], and the user's role to [Role.trusted].
	// static Future<void> makeLeader(Student student) async {
	// 	final studentsField = Identifier.students.name, roleField = Identifier.role.name;
	// 	await EntityCollection.groups.ref.update({
	// 		'$studentsField.${Local.userId}.$roleField': Role.trusted.index,
	// 		'$studentsField.${student.id}.$roleField': Role.leader.index
	// 	});
	// 	_userRole = Role.trusted;
	// }

	// /// Updates the user's name.
	// static Future<void> updateName() async {
	// 	await EntityCollection.groups.ref.update({
	// 		'${Identifier.students.name}.${Local.userId}.${Identifier.name.name}': Local.userName
	// 	});
	// }

	// /// Deletes the [event].
	// static Future<void> deleteEvent(Event event) async {
	// 	await Future.wait([
	// 		EntityCollection.events.ref.update({event.id: FieldValue.delete()}),
	// 		EntityCollection.events.detailsRef(event.id).delete()
	// 	]);
	// }

	// /// Deletes the [subject] and its [Event]s.
	// static Future<void> deleteSubject(Subject subject) async {
	// 	await Future.wait([
	// 		EntityCollection.subjects.ref.update({subject.id: FieldValue.delete()}),
	// 		EntityCollection.subjects.detailsRef(subject.id).delete(),
	// 		EntityCollection.events.ref.update({
	// 			for (final event in subject.events!) event.id: FieldValue.delete()
	// 		})
	// 	]);
	// }

	// /// Deletes the [message].
	// static Future<void> deleteMessage(Message message) async {
	// 	await Future.wait([
	// 		EntityCollection.messages.ref.update({message.id: FieldValue.delete()}),
	// 		EntityCollection.messages.detailsRef(message.id).delete()
	// 	]);
	// }
}
