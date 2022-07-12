import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/message.dart';


class MessagesNotifier extends StateNotifier<Iterable<Message>?> {
	MessagesNotifier({required this.repository}) : super(null) {
		repository.messages().then((messages) => state = messages.toList()..sort());
	}

	final HomeRepository repository;
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, Iterable<Message>?>((ref) {
	return MessagesNotifier(repository: ref.watch(homeRepositoryProvider));
});
