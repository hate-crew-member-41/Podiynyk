import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/main.dart';

import 'package:podiinyk/states/home/domain/entities/event.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';

import '../../data/user_repository.dart';
import '../id.dart';
import 'user.dart';


final initialUserProvider = StateProvider<User?>((ref) => null);


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
			irrelevantEventIds: const <String>{},
			chosenSubjectIds: const <String>{}
		);
		await repository.createGroup(user: user);
		state = user;
	}

	Future<void> joinGroup(String id) async {
		final user = state.copyWith(
			info: state.info,
			groupId: id,
			irrelevantEventIds: const <String>{},
			chosenSubjectIds: const <String>{}
		);
		await repository.joinGroup(user: user);
		state = user;
	}

	// do: define toggleEventIsRelevant, toggleSubjectIsStudied

	Future<void> setIrrelevant(Event event) => _update(
		info: state.info,
		irrelevantEventIds: state.irrelevantEventIds!.toSet()..add(event.id),
		chosenSubjectIds: state.chosenSubjectIds
	);

	Future<void> setRelevant(Event event) => _update(
		info: state.info,
		irrelevantEventIds: state.irrelevantEventIds!.toSet()..remove(event.id),
		chosenSubjectIds: state.chosenSubjectIds
	);

	Future<void> setStudied(Subject subject) => _update(
		info: state.info,
		irrelevantEventIds: state.irrelevantEventIds,
		chosenSubjectIds: state.chosenSubjectIds!.toSet()..add(subject.id)
	);

	Future<void> setUnstudied(Subject subject) => _update(
		info: state.info,
		irrelevantEventIds: state.irrelevantEventIds,
		chosenSubjectIds: state.chosenSubjectIds!.toSet()..remove(subject.id)
	);

	Future<void> update({String? firstName, String? lastName, required String? info}) => _update(
		firstName: firstName,
		lastName: lastName,
		info: info,
		irrelevantEventIds: state.irrelevantEventIds,
		chosenSubjectIds: state.chosenSubjectIds
	);

	Future<void> _update({
		String? firstName,
		String? lastName,
		required String? info,
		required Set<String>? irrelevantEventIds,
		required Set<String>? chosenSubjectIds
	}) async {
		final user = state.copyWith(
			firstName: firstName,
			lastName: lastName,
			info: info,
			groupId: state.groupId,
			irrelevantEventIds: irrelevantEventIds,
			chosenSubjectIds: chosenSubjectIds
		);
		await repository.update(user);
		state = user;
	}

	Future<void> leaveGroup() async {
		await repository.leaveGroup(user: state);
		state = state.copyWith(
			info: state.info,
			groupId: null,
			irrelevantEventIds: null,
			chosenSubjectIds: null
		);
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
