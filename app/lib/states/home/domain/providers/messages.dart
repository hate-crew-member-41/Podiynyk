import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/message.dart';


class MessagesNotifier extends StateNotifier<List<Message>?> {
	MessagesNotifier({required this.repository}) : super(null) {
		if (repository != null) _init();
	}

	final HomeRepository? repository;

	Future<void> _init() async {
		final messages = await repository!.messages();
		state = messages.toList()..sort();
	}

	Future<void> add(Message message) async {
		await repository!.addMessage(message);
		state = state!.toList()..add(message)..sort();
	}

	Future<void> delete(Message message) async {
		await repository!.deleteMessage(message);
		state = state!.toList()..remove(message);
	}
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, List<Message>?>(
	(ref) => MessagesNotifier(repository: ref.watch(homeRepositoryProvider))
);
