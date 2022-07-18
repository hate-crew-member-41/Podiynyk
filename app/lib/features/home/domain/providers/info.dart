import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/info.dart';


class InfoNotifier extends StateNotifier<Iterable<Info>?> {
	InfoNotifier({required this.repository}) : super(null) {
		repository.info().then((info) => state = info.toList()..sort());
	}

	final HomeRepository repository;

	Future<void> add(Info item) async {
		await repository.addInfo(item);
		state = [...state!, item]..sort();
	}
}

final infoProvider = StateNotifierProvider<InfoNotifier, Iterable<Info>?>((ref) {
	return InfoNotifier(repository: ref.watch(homeRepositoryProvider));
});
