import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/info.dart';


class InfoNotifier extends StateNotifier<List<Info>?> {
	InfoNotifier({required this.repository}) : super(null) {
		if (repository != null) _init();
	}

	final HomeRepository? repository;

	Future<void> _init() async {
		final info = await repository!.info();
		state = info.toList()..sort();
	}

	Future<void> add(Info item) async {
		await repository!.addInfo(item);
		state = state!.toList()..add(item)..sort();
	}

	Future<void> delete(Info item) async {
		await repository!.deleteInfo(item);
		state = state!.toList()..remove(item);
	}
}

final infoProvider = StateNotifierProvider<InfoNotifier, List<Info>?>(
	(ref) => InfoNotifier(repository: ref.watch(homeRepositoryProvider))
);
