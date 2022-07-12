import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/student.dart';


class StudentsNotifier extends StateNotifier<Iterable<Student>?> {
	StudentsNotifier({required this.repository}) : super(null) {
		repository.students().then((students) => state = students);
	}

	final HomeRepository repository;
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, Iterable<Student>?>((ref) {
	return StudentsNotifier(repository: ref.watch(homeRepositoryProvider));
});
