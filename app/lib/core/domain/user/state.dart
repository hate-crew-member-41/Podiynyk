import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/states/home/domain/entities/subject.dart';

import '../../data/user_repository.dart';
import 'user.dart';


final initialUserProvider = StateProvider<User?>((ref) {
	return null;
});


class UserNotifier extends StateNotifier<User> {
	UserNotifier({
		required User initial,
		required this.repository
	}) :
		super(initial);

	final UserRepository repository;

	Future<void> createGroup() async {
		// do: change
		final id = DateTime.now().microsecondsSinceEpoch.toString();
		final user = state.copyWith(
			groupId: id,
			chosenSubjectIds: const <String>{}
		);
		await repository.createGroup(user: user);
		state = user;
	}

	Future<void> joinGroup(String id) async {
		final user = state.copyWith(
			groupId: id,
			chosenSubjectIds: const <String>{}
		);
		await repository.joinGroup(user: user);
		state = user;
	}

	Future<void> setStudied(Subject subject) async {
		await repository.setSubjectStudied(subject, user: state);
		state = state.copyWith(
			groupId: state.groupId,
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..add(subject.id)
		);
	}

	Future<void> setUnstudied(Subject subject) async {
		await repository.setSubjectUnstudied(subject, user: state);
		state = state.copyWith(
			groupId: state.groupId,
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..remove(subject.id)
		);
	}

	Future<void> leave() async {
		await repository.leaveGroup(user: state);
		state = state.copyWith(groupId: null, chosenSubjectIds: null);
	}
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
	(ref) => UserNotifier(
		initial: ref.watch(initialUserProvider)!,
		repository: ref.watch(userRepositoryProvider)
	)
);
