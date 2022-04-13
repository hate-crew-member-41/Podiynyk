import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'identifier.dart';
import 'local.dart';

import 'entities/candidate.dart';
import 'entities/entity.dart';
import 'entities/event.dart';
import 'entities/message.dart';
import 'entities/student.dart';
import 'entities/subject.dart';


typedef CloudMap = Map<String, dynamic>;


/// A collection of the group, stored in [FirebaseFirestore].
enum Collection {
	events,
	groups,
	messages,
	students,
	subjects
}

extension CollectionRefs on Collection {
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
			Identifier.joinedTime.name: DateTime.now()
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
				...{
					'${Local.userId}.${Identifier.confirmationCount.name}': 0,
					'${Local.userId}.${Identifier.joinedTime.name}': DateTime.now()
				}
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
	static Stream<List<Candidate>?> get leaderElectionUpdates {
		return Collection.students.ref.snapshots().map((snapshot) {
			final entries = snapshot.data()!.entries;
			final leaderIsElected = (entries.first.value as CloudMap).containsKey(Identifier.role.name);

			if (!leaderIsElected) return [
				for (final entry in entries) Candidate.fromCloud(
					id: entry.key,
					object: entry.value
				)
			]..sort();

			return null;
		});
	}

	/// Adds a confirmation for the [candidate] and removes one for the [previous] voted-for [Candidate].
	static Future<void> confirmCandidate(Candidate candidate, {Candidate? previous}) async {
		await Collection.students.ref.update({
			'${candidate.id}.confirmationCount': FieldValue.increment(1),
			if (previous != null)
				'${previous.id}.confirmationCount': FieldValue.increment(-1)
		});
	}

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

	/// The group's sorted [Student]s. Updates [Local.userRole].
	static Future<List<Student>> get students async {
		final snapshot = await Collection.students.ref.get();

		final students = [
			for (final entry in snapshot.data()!.entries) Student.fromCloud(id: entry.key, object: entry.value as CloudMap)
		]..sort();
		Local.clearEntityLabels(students);

		Local.userRole = students.firstWhere((student) => student.id == Local.userId).role!;
		return students;
	}

	/// The [entity]'s details.
	static Future<CloudMap> entityDetails(Entity entity) async {
		final snapshot = await entity.cloudCollection!.detailsRef(entity).get();
		return snapshot.data()!;
	}

	/// Updates the [entity].
	static Future<void> updateEntity(Entity entity) async {
		await entity.cloudCollection!.ref.update({
			entity.id: entity.inCloudFormat
		});
	}

	/// Updates the [entity]'s details.
	static Future<void> updateEntityDetails(Entity entity) async {
		await entity.cloudCollection!.detailsRef(entity).update(entity.detailsInCloudFormat!);
	}

	/// Sets the [student]'s [Role] to [Role.leader] and the user's [Role] to [Role.ordinary].
	/// Updates [Local.userRole].
	static Future<void> makeLeader(Student student) async {
		await Collection.students.ref.update({
			'${student.id}.${Identifier.role.name}': Role.leader.index,
			'${Local.userId}.${Identifier.role.name}': Role.trusted.index
		});
		Local.userRole = Role.trusted;
	}

	/// Deletes the [entity].
	static Future<void> deleteEntity(Entity entity) async {
		await Future.wait([
			entity.cloudCollection!.ref.update({entity.id: FieldValue.delete()}),
			entity.cloudCollection!.detailsRef(entity).delete()
		]);
	}

	/// Deletes the [events].
	static Future<void> deleteEvents(List<Event> events) async {
		await Future.wait([
			Collection.events.ref.update({
				for (final event in events)
					event.id: FieldValue.delete()
			}),
			for (final event in events)
				Collection.events.detailsRef(event).delete()
		]);
	}
}
