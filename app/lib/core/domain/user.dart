import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/features/home/data/repository.dart';
import 'package:podiinyk/features/home/domain/entities/student.dart';
import 'package:podiinyk/features/home/domain/entities/subject.dart';


class UserNotifier extends StateNotifier<Student> {
	UserNotifier({required this.repository}): super(const Student(
		id: 'userId',
		name: 'Name',
		surname: 'Surname',
		chosenSubjectIds: <String>{}
	));

	final HomeRepository repository;

	Future<void> setStudied(Subject subject) async {
		await repository.setSubjectStudied(subject, user: state);
		_updateStudied(state.chosenSubjectIds.toSet()..add(subject.id));
	}

	Future<void> setUnstudied(Subject subject) async {
		await repository.setSubjectUnstudied(subject, user: state);
		_updateStudied(state.chosenSubjectIds.toSet()..remove(subject.id));
	}

	void _updateStudied(Set<String> ids) {
		state = Student(
			id: state.id,
			name: state.name,
			surname: state.surname,
			chosenSubjectIds: ids
		);
	}
}

final userProvider = StateNotifierProvider<UserNotifier, Student>(
	(ref) => UserNotifier(repository: ref.watch(homeRepositoryProvider))
);
