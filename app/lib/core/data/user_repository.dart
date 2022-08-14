import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user/user.dart';

import 'types/document.dart';
import 'types/field.dart';
import 'types/object_map.dart';

import 'user_doc_ref.dart';


// do: remove duplication
// do: failures
class UserRepository {
	const UserRepository();

	Future<void> initAccount(User user) async {
		await userDocRef(user.id).set({
			Field.name.name: [user.firstName, user.lastName]
		});
	}

	Future<User> user({required String id}) async {
		final snapshot = await userDocRef(id).get();
		final map = snapshot.data()!;

		final name = map[Field.name.name] as List<dynamic>;
		final groupId = map[Field.groupId.name];
		final hasGroup = groupId != null;

		return User(
			id: id,
			firstName: name.first,
			lastName: name.last,
			info: map[Field.info.name],
			groupId: groupId,
			irrelevantEventIds: hasGroup ? Set<String>.from(map[Field.irrelevantEvents.name]) : null,
			chosenSubjectIds: hasGroup ? Set<String>.from(map[Field.chosenSubjects.name]) : null
		);
	}

	Future<void> createGroup({required User user}) async {
		final groupId = user.groupId!;
		final chosenSubjectIds = user.chosenSubjectIds!.toList();
		const emptyMap = <String, ObjectMap>{};

		await Future.wait([
			userDocRef(user.id).update({
				Field.groupId.name: groupId,
				Field.irrelevantEvents.name: user.irrelevantEventIds!.toList(),
				Field.chosenSubjects.name: chosenSubjectIds
			}),
			Document.events.ref(groupId).set(emptyMap),
			Document.subjects.ref(groupId).set(emptyMap),
			Document.info.ref(groupId).set(emptyMap),
			Document.messages.ref(groupId).set(emptyMap),
			Document.students.ref(groupId).set({
				user.id: {
					Field.name.name: [user.firstName, user.lastName],
					Field.chosenSubjects.name: chosenSubjectIds
				}
			})
		]);
	}

	Future<void> joinGroup({required User user}) async {
		final chosenSubjectIds = user.chosenSubjectIds!.toList();

		await Future.wait([
			userDocRef(user.id).update({
				Field.groupId.name: user.groupId,
				Field.irrelevantEvents.name: user.irrelevantEventIds!.toList(),
				Field.chosenSubjects.name: chosenSubjectIds
			}),
			Document.students.ref(user.groupId!).update({
				user.id: {
					Field.name.name: [user.firstName, user.lastName],
					Field.chosenSubjects.name: chosenSubjectIds
				}
			})
		]);
	}

	Future<void> update(User user) async {
		final name = [user.firstName, user.lastName];
		final chosenSubjectIds = user.chosenSubjectIds?.toList();
		final hasGroup = user.groupId != null;

		await Future.wait([
			userDocRef(user.id).update({
				Field.name.name: name,
				Field.info.name: user.info,
				if (hasGroup) Field.irrelevantEvents.name: user.irrelevantEventIds!.toList(),
				if (hasGroup) Field.chosenSubjects.name: chosenSubjectIds
			}),
			// think: do not update if User.name and User.chosenSubjectIds have not changed
			Document.students.ref(user.groupId!).update({
				'${user.id}.${Field.name.name}': name,
				if (hasGroup) '${user.id}.${Field.chosenSubjects.name}': chosenSubjectIds
			})
		]);
	}

	Future<void> leaveGroup({required User user}) async {
		await Future.wait([
			userDocRef(user.id).update({
				Field.groupId.name: FieldValue.delete(),
				Field.irrelevantEvents.name: FieldValue.delete(),
				Field.chosenSubjects.name: FieldValue.delete()
			}),
			Document.students.ref(user.groupId!).update({
				user.id: FieldValue.delete()
			}),
		]);
	}

	// do: change after it is possible to manage the account without the group specified
	Future<void> deleteAccount(User user) async {
		final groupId = user.groupId!;
		final messagesSnapshot = await Document.messages.ref(groupId).get();
		final messageEntries = messagesSnapshot.data()!.entries.where(
			(entry) => entry.value[Field.author.name] == user.id
		);

		await Future.wait([
			// fix: guarantee a recent sign in
			FirebaseAuth.instance.currentUser!.delete(),
			userDocRef(user.id).delete(),
			Document.students.ref(groupId).update({
				user.id: FieldValue.delete()
			}),
			Document.messages.ref(groupId).update({
				for (final entry in messageEntries) entry.key: FieldValue.delete()
			})
		]);
	}
}

final userRepositoryProvider = Provider<UserRepository>(
	(ref) => const UserRepository()
);
