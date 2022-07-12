import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/event.dart';


// think: capture common logic
class EventsNotifier extends StateNotifier<Iterable<Event>?> {
	EventsNotifier({required this.repository}) : super(null) {
		repository.events().then((events) => state = events);
	}

	final HomeRepository repository;
}

final eventsProvider = StateNotifierProvider<EventsNotifier, Iterable<Event>?>((ref) {
	return EventsNotifier(repository: ref.watch(homeRepositoryProvider));
});
