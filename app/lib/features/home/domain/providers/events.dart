import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/event.dart';


// think: define EntitiesNotifier
class EventsNotifier extends StateNotifier<List<Event>?> {
	EventsNotifier({required this.repository}) : super(null) {
		repository.events().then((events) => state = events.toList()..sort());
	}

	final HomeRepository repository;

	Future<void> add(Event event) async {
		await repository.addEvent(event);
		state = state!.toList()..add(event)..sort();
	}

	Future<void> delete(Event event) async {
		await repository.deleteEvent(event);
		state = state!.toList()..remove(event);
	}
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>?>((ref) {
	return EventsNotifier(repository: ref.watch(homeRepositoryProvider));
});
