import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/states/home/domain/entities/subject.dart';
import '../domain/user/user.dart';

import 'types/document.dart';
import 'types/field.dart';
import 'types/object_map.dart';


// do: remove duplication
// do: failures
class UserRepository {
	const UserRepository();

	Future<void> initAccount(User user) async {
		await UserRepository._docRef(user.id).set({
			Field.name.name: [user.firstName, user.lastName]
		});
	}

	Future<User> user({required String id}) async {
		final snapshot = await UserRepository._docRef(id).get();
		final map = snapshot.data()!;
		final name = map[Field.name.name] as List<dynamic>;
		return User(
			id: id,
			firstName: name.first,
			lastName: name.last,
			groupId: map[Field.groupId.name],
			chosenSubjectIds: map.containsKey(Field.chosenSubjects.name) ?
				Set<String>.from(map[Field.chosenSubjects.name]) :
				null
		);
	}

	Future<void> createGroup({required User user}) async {
		final groupId = user.groupId!;
		final chosenSubjectIds = user.chosenSubjectIds!.toList();
		const emptyMap = <String, ObjectMap>{};

		await Future.wait([
			Document.events.ref(groupId: groupId).set(emptyMap),
			Document.subjects.ref(groupId: groupId).set(emptyMap),
			Document.info.ref(groupId: groupId).set(emptyMap),
			Document.messages.ref(groupId: groupId).set(emptyMap),
			Document.students.ref(groupId: groupId).set({
				user.id: {
					Field.name.name: [user.firstName, user.lastName],
					Field.chosenSubjects.name: chosenSubjectIds
				}
			}),
			_docRef(user.id).update({
				Field.groupId.name: groupId,
				Field.chosenSubjects.name: chosenSubjectIds
			})
		]);
	}

	Future<void> joinGroup({required User user}) async {
		final chosenSubjectIds = user.chosenSubjectIds!.toList();

		await Future.wait([
			_docRef(user.id).update({
				Field.groupId.name: user.groupId,
				Field.chosenSubjects.name: chosenSubjectIds
			}),
			Document.students.ref(groupId: user.groupId!).update({
				user.id: {
					Field.name.name: [user.firstName, user.lastName],
					Field.chosenSubjects.name: chosenSubjectIds
				}
			})
		]);
	}

	Future<void> setSubjectStudied(Subject subject, {required User user}) async {
		await Future.wait<void>([
			_docRef(user.id).update({
				Field.chosenSubjects.name: FieldValue.arrayUnion([subject.id])
			}),
			Document.students.ref(groupId: user.groupId!).update({
				'${user.id}.${Field.chosenSubjects.name}': FieldValue.arrayUnion([subject.id])
			})
		]);
	}

	Future<void> setSubjectUnstudied(Subject subject, {required User user}) async {
		await Future.wait<void>([
			_docRef(user.id).update({
				Field.chosenSubjects.name: FieldValue.arrayRemove([subject.id])
			}),
			Document.students.ref(groupId: user.groupId!).update({
				'${user.id}.${Field.chosenSubjects.name}': FieldValue.arrayRemove([subject.id])
			})
		]);
	}

	Future<void> leaveGroup({required User user}) async {
		await Future.wait([
			_docRef(user.id).update({
				Field.groupId.name: FieldValue.delete(),
				Field.chosenSubjects.name: FieldValue.delete()
			}),
			Document.students.ref(groupId: user.groupId!).update({
				user.id: FieldValue.delete()
			}),
		]);
	}

	// do: change after it is possible to manage the account without the group specified
	Future<void> deleteAccount(User user) async {
		final groupId = user.groupId!;
		// think: keep a local copy of the user's messages to prevent reading them
		final messagesSnapshot = await Document.messages.ref(groupId: groupId).get();
		final messageEntries = messagesSnapshot.data()!.entries.where(
			(entry) => entry.value[Field.author.name] == user.id
		);

		await Future.wait([
			FirebaseAuth.instance.currentUser!.delete(),
			_docRef(user.id).delete(),
			Document.students.ref(groupId: groupId).update({
				user.id: FieldValue.delete()
			}),
			Document.messages.ref(groupId: groupId).update({
				for (final entry in messageEntries) entry.key: FieldValue.delete()
			})
		]);
	}

	static DocumentReference<ObjectMap> _docRef(String id) {
		return FirebaseFirestore.instance.collection('users').doc(id);
	}
}

final userRepositoryProvider = Provider<UserRepository>(
	(ref) => const UserRepository()
);
