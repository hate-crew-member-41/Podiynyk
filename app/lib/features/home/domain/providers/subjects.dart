import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/subject.dart';


class SubjectsNotifier extends StateNotifier<Iterable<Subject>?> {
	SubjectsNotifier({required this.repository}) : super(null) {
		repository.subjects().then((subjects) => state = subjects);
	}

	final HomeRepository repository;
}

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, Iterable<Subject>?>((ref) {
	return SubjectsNotifier(repository: ref.watch(homeRepositoryProvider));
});
