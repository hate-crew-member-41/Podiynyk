import 'package:cloud_firestore/cloud_firestore.dart';
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

	Future<void> initUser(User user) async {
		await UserRepository._docRef(user.id).set({
			Field.name.name: [user.name, user.surname]
		});
	}

	Future<User> user(String id) async {
		final snapshot = await UserRepository._docRef(id).get();
		final map = snapshot.data()!;
		return User(
			id: id,
			name: map[Field.name.name].first,
			surname: map[Field.name.name].last,
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
			Document.events.ref(groupId).set(emptyMap),
			Document.subjects.ref(groupId).set(emptyMap),
			Document.info.ref(groupId).set(emptyMap),
			Document.messages.ref(groupId).set(emptyMap),
			Document.students.ref(groupId).set({
				user.id: {
					Field.name.name: [user.name, user.surname],
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
			Document.students.ref(user.groupId!).update({
				user.id: {
					Field.name.name: [user.name, user.surname],
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
			Document.students.ref(user.groupId!).update({
				'${user.id}.${Field.chosenSubjects.name}': FieldValue.arrayUnion([subject.id])
			})
		]);
	}

	Future<void> setSubjectUnstudied(Subject subject, {required User user}) async {
		await Future.wait<void>([
			_docRef(user.id).update({
				Field.chosenSubjects.name: FieldValue.arrayRemove([subject.id])
			}),
			Document.students.ref(user.groupId!).update({
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
			Document.students.ref(user.groupId!).update({
				user.id: FieldValue.delete()
			}),
		]);
	}

	static DocumentReference<ObjectMap> _docRef(String id) {
		return FirebaseFirestore.instance.collection('users').doc(id);
	}
}

final userRepositoryProvider = Provider<UserRepository>(
	(ref) => const UserRepository()
);
