import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';

import '../../data/user_repository.dart';
import '../id.dart';
import 'user.dart';


// do: review
final initialUserProvider = StateProvider<User?>((ref) {
	return null;
});


class UserNotifier extends StateNotifier<User> {
	UserNotifier({
		required User initial,
		required this.repository,
		required this.appStateController
	}) :
		super(initial);

	final UserRepository repository;
	final StateController<AppState> appStateController;

	Future<void> createGroup() async {
		final id = newId(user: state);
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

	Future<void> leaveGroup() async {
		await repository.leaveGroup(user: state);
		state = state.copyWith(groupId: null, chosenSubjectIds: null);
		appStateController.state = AppState.identification;
	}

	Future<void> signOut() async {
		await FirebaseAuth.instance.signOut();
		appStateController.state = AppState.auth;
	}

	Future<void> deleteAccount() async {
		await repository.deleteAccount(state);
		appStateController.state = AppState.auth;
	}
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
	// (ref) => UserNotifier(
	// 	initial: ref.watch(initialUserProvider)!,
	// 	repository: ref.watch(userRepositoryProvider),
	// 	appController: ref.watch(appStateProvider.notifier)
	// )
	(ref) {
		print('UserNotifier');
		return UserNotifier(
			initial: ref.watch(initialUserProvider)!,
			repository: ref.watch(userRepositoryProvider),
			appStateController: ref.watch(appStateProvider.notifier)
		);
	}
);
