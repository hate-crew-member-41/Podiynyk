import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/features/home/domain/entities/message.dart';
import 'package:podiinyk/features/home/domain/entities/subject.dart';

import '../data/user_repository.dart';


class StudentUser {
	const StudentUser({
		required this.id,
		required this.name,
		required this.surname,
		this.groupId,
		this.chosenSubjectIds
	});

	final String id;
	final String name;
	final String surname;
	final String? groupId;
	final Set<String>? chosenSubjectIds;

	bool studies(Subject subject) {
		return subject.isCommon || chosenSubjectIds!.contains(subject.id);
	}

	bool isAuthor(Message message) => id == message.author.id;

	StudentUser copyWith({
		String? groupId,
		Set<String>? chosenSubjectIds
	}) => StudentUser(
		id: id,
		name: name,
		surname: surname,
		groupId: groupId ?? this.groupId,
		chosenSubjectIds: chosenSubjectIds ?? this.chosenSubjectIds
	);
}


final initialUserProvider = StateProvider<StudentUser?>((ref) {
	return null;
});


class UserNotifier extends StateNotifier<StudentUser> {
	UserNotifier({
		required StudentUser initial,
		required this.repository
	}) :
		super(initial);

	final UserRepository repository;

	Future<void> enterNewGroup() async {
		// do: change
		final groupId = DateTime.now().microsecondsSinceEpoch.toString();
		final user = state.copyWith(
			groupId: groupId,
			chosenSubjectIds: const <String>{}
		);

		await repository.initGroup(user: user);
		state = user;
	}

	Future<void> setStudied(Subject subject) async {
		await repository.setSubjectStudied(subject, user: state);
		state = state.copyWith(
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..add(subject.id)
		);
	}

	Future<void> setUnstudied(Subject subject) async {
		await repository.setSubjectUnstudied(subject, user: state);
		state = state.copyWith(
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..remove(subject.id)
		);
	}

	Future<void> leave() async {
		await repository.leaveGroup(user: state);
		state = state.copyWith(groupId: null, chosenSubjectIds: null);
	}
}

final userProvider = StateNotifierProvider<UserNotifier, StudentUser>(
	(ref) => UserNotifier(
		initial: ref.watch(initialUserProvider)!,
		repository: ref.watch(userRepositoryProvider)
	)
);
