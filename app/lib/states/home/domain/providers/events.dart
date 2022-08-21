import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repository.dart';
import '../entities/event.dart';
import '../entities/subject.dart';


// think: define relevantEvents, irrelevantEvents
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

	void removeSubjectEvents(Subject subject) {
		state = state!.toList()..removeWhere((e) => e.subject == subject);
	}

	void removeAllSubjectEvents() {
		state = state!.toList()..removeWhere((e) => e.subject != null);
	}
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>?>(
	(ref) => EventsNotifier(repository: ref.watch(homeRepositoryProvider))
);
