import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/student.dart';


class StudentsNotifier extends StateNotifier<List<Student>?> {
	StudentsNotifier({required HomeRepository repository}) : super(null) {
		repository.students().then((students) => state = students.toList()..sort());
	}
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>?>(
	(ref) => StudentsNotifier(repository: ref.watch(homeRepositoryProvider))
);


class StudentDetailsNotifier extends StateNotifier<StudentDetails?> {
	StudentDetailsNotifier(this.student, {required this.repository}) : super(null) {
		_init();
	}

	final Student student;
	final HomeRepository repository;

	Future<void> _init() async {
		final details = await repository.studentDetails(student);
		state = details.withSubjects(details.subjects.toList()..sort());
	}
}

final studentDetailsFamily = StateNotifierProvider.family<StudentDetailsNotifier, StudentDetails?, Student>(
	(ref, student) => StudentDetailsNotifier(student, repository: ref.watch(homeRepositoryProvider))
);
