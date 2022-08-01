import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/features/home/data/repository.dart';
import 'package:podiinyk/features/home/domain/entities/message.dart';
import 'package:podiinyk/features/home/domain/entities/subject.dart';


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

	final HomeRepository repository;

	Future<void> setStudied(Subject subject) async {
		await repository.setSubjectStudied(subject, user: state);
		_updateStudied(state.chosenSubjectIds!.toSet()..add(subject.id));
	}

	Future<void> setUnstudied(Subject subject) async {
		await repository.setSubjectUnstudied(subject, user: state);
		_updateStudied(state.chosenSubjectIds!.toSet()..remove(subject.id));
	}

	void _updateStudied(Set<String> ids) {
		state = StudentUser(
			id: state.id,
			name: state.name,
			surname: state.surname,
			groupId: state.groupId,
			chosenSubjectIds: ids
		);
	}
}

final userProvider = StateNotifierProvider<UserNotifier, StudentUser>(
	(ref) => UserNotifier(
		initial: ref.watch(initialUserProvider)!,
		repository: ref.watch(homeRepositoryProvider)
	)
);
