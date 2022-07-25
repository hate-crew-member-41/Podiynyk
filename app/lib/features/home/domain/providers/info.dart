import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/info.dart';


class InfoNotifier extends StateNotifier<List<Info>?> {
	InfoNotifier({required this.repository}) : super(null) {
		repository.info().then((info) => state = info.toList()..sort());
	}

	final HomeRepository repository;

	Future<void> add(Info item) async {
		await repository.addInfo(item);
		state = state!.toList()..add(item)..sort();
	}

	Future<void> delete(Info item) async {
		await repository.deleteInfo(item);
		state = state!.toList()..remove(item);
	}
}

final infoProvider = StateNotifierProvider<InfoNotifier, List<Info>?>((ref) {
	return InfoNotifier(repository: ref.watch(homeRepositoryProvider));
});
