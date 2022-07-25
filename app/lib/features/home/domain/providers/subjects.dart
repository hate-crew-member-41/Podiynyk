import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/info.dart';
import '../entities/subject.dart';


class SubjectsNotifier extends StateNotifier<List<Subject>?> {
	SubjectsNotifier({required this.repository}) : super(null) {
		repository.subjects().then((subjects) => state = subjects.toList()..sort());
	}

	final HomeRepository repository;

	Future<void> add(Subject subject) async {
		await repository.addSubject(subject);
		state = state!.toList()..add(subject)..sort();
	}

	Future<void> delete(Subject subject) async {
		await repository.deleteSubject(subject);
		state = state!.toList()..remove(subject);
	}
}

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>?>((ref) {
	return SubjectsNotifier(repository: ref.watch(homeRepositoryProvider));
});


class SubjectInfoNotifier extends StateNotifier<SubjectDetails?> {
	SubjectInfoNotifier(this.subject, {required this.repository}): super(null) {
		repository.subjectDetails(subject).then((details) => state = SubjectDetails(
			info: details.info.toList()..sort(),
			students: details.students?.toList()?..sort()
		));
	}

	final Subject subject;
	final HomeRepository repository;

	Future<void> addInfo(Info item) async {
		await repository.addSubjectInfo(subject, item);
		state = state!.withInfo(state!.info.toList()..add(item)..sort());
	}

	Future<void> deleteInfo(Info item) async {
		await repository.deleteSubjectInfo(subject, item);
		state = state!.withInfo(state!.info.toList()..remove(item));
	}
}

final subjectDetailsProviders = StateNotifierProvider.family<SubjectInfoNotifier, SubjectDetails?, Subject>((ref, subject) {
	return SubjectInfoNotifier(subject, repository: ref.watch(homeRepositoryProvider));
});
