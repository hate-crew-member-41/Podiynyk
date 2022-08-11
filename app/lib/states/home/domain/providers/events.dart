import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/event.dart';


// think: define EntitiesNotifier
class EventsNotifier extends StateNotifier<List<Event>?> {
	EventsNotifier({required this.repository}) : super(null) {
		if (repository != null) _init();
	}

	final HomeRepository? repository;

	Future<void> _init() async {
		final events = await repository!.events();
		state = events.toList()..sort();
	}

	Future<void> add(Event event) async {
		await repository!.addEvent(event);
		state = state!.toList()..add(event)..sort();
	}

	Future<void> delete(Event event) async {
		await repository!.deleteEvent(event);
		state = state!.toList()..remove(event);
	}
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>?>(
	(ref) => EventsNotifier(repository: ref.watch(homeRepositoryProvider))
);
