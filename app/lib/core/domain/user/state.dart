import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';

import '../../data/user_repository.dart';
import '../id.dart';
import 'user.dart';


final initialUserProvider = StateProvider<User?>((ref) {
	return null;
});


// do: be consistent with passing the current or the updated User to HomeRepository
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
			info: state.info,
			groupId: id,
			chosenSubjectIds: const <String>{}
		);
		await repository.createGroup(user: user);
		state = user;
	}

	Future<void> joinGroup(String id) async {
		final user = state.copyWith(
			info: state.info,
			groupId: id,
			chosenSubjectIds: const <String>{}
		);
		await repository.joinGroup(user: user);
		state = user;
	}

	// think: merge with this.update
	Future<void> setStudied(Subject subject) async {
		await repository.setSubjectStudied(subject, user: state);
		state = state.copyWith(
			info: state.info,
			groupId: state.groupId,
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..add(subject.id)
		);
	}

	// think: merge with this.update
	Future<void> setUnstudied(Subject subject) async {
		await repository.setSubjectUnstudied(subject, user: state);
		state = state.copyWith(
			info: state.info,
			groupId: state.groupId,
			chosenSubjectIds: state.chosenSubjectIds!.toSet()..remove(subject.id)
		);
	}

	Future<void> update({String? firstName, String? lastName, required String? info}) async {
		final user = state.copyWith(
			firstName: firstName,
			lastName: lastName,
			info: info,
			groupId: state.groupId,
			chosenSubjectIds: state.chosenSubjectIds
		);
		await repository.update(user);
		state = user;
	}

	Future<void> leaveGroup() async {
		await repository.leaveGroup(user: state);
		state = state.copyWith(info: state.info, groupId: null, chosenSubjectIds: null);
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
	(ref) => UserNotifier(
		initial: ref.watch(initialUserProvider)!,
		repository: ref.watch(userRepositoryProvider),
		appStateController: ref.watch(appStateProvider.notifier)
	)
);
