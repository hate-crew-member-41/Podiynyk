import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';

import '../entities/info.dart';
import '../entities/subject.dart';

import 'events.dart';


// think: define studiedSubjects, unstudiedSubjects
class SubjectsNotifier extends StateNotifier<List<Subject>?> {
	SubjectsNotifier({
		required this.eventsNotifier,
		required this.repository
	}) : super(null) {
		if (repository != null) _init();
	}

	final EventsNotifier eventsNotifier;
	final HomeRepository? repository;

	Future<void> _init() async {
		final subjects = await repository!.subjects();
		state = subjects.toList()..sort();
	}

	Future<void> add(Subject subject) async {
		await repository!.addSubject(subject);
		state = state!.toList()..add(subject)..sort();
	}

	Future<void> delete(Subject subject) async {
		await repository!.deleteSubject(subject);
		state = state!.toList()..remove(subject);
		eventsNotifier.removeSubjectEvents(subject);
	}

	Future<void> clear() async {
		await repository!.clearSubjects();
		state = const <Subject>[];
		eventsNotifier.removeAllSubjectEvents();
	}
}

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, List<Subject>?>(
	(ref) => SubjectsNotifier(
		eventsNotifier: ref.watch(eventsProvider.notifier),
		repository: ref.watch(homeRepositoryProvider),
	)
);


class SubjectDetailsNotifier extends StateNotifier<SubjectDetails?> {
	SubjectDetailsNotifier(this.subject, {required this.repository}) : super(null) {
		if (repository != null) _init();
	}

	final Subject subject;
	final HomeRepository? repository;

	Future<void> _init() async {
		final details = await repository!.subjectDetails(subject);
		state = SubjectDetails(
			info: details.info.toList()..sort(),
			students: details.students?.toList()?..sort()
		);
	}

	Future<void> addInfo(Info item) async {
		await repository!.addSubjectInfo(subject, item);
		state = state!.withInfo(state!.info.toList()..add(item)..sort());
	}

	Future<void> deleteInfo(Info item) async {
		await repository!.deleteSubjectInfo(subject, item);
		state = state!.withInfo(state!.info.toList()..remove(item));
	}
}

final subjectDetailsFamily = StateNotifierProvider.family<SubjectDetailsNotifier, SubjectDetails?, Subject>(
	(ref, subject) => SubjectDetailsNotifier(subject, repository: ref.watch(homeRepositoryProvider))
);
