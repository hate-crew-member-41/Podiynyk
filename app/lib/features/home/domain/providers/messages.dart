import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/message.dart';


class MessagesNotifier extends StateNotifier<List<Message>?> {
	MessagesNotifier({required this.repository}) : super(null) {
		repository.messages().then((messages) => state = messages.toList()..sort());
	}

	final HomeRepository repository;

	Future<void> add(Message message) async {
		await repository.addMessage(message);
		state = [...state!, message]..sort();
	}
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, List<Message>?>((ref) {
	return MessagesNotifier(repository: ref.watch(homeRepositoryProvider));
});
