import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/domain/home/entities/event.dart';
import 'package:podiinyk/domain/home/entities/subject.dart';

import '../core/types/document.dart';
import '../core/types/object_map.dart';
import 'models/event.dart';
import 'models/subjects.dart';


// do: failures
// do: prevent unnecessary reads
class HomeRepository {
	const HomeRepository();

	Future<Iterable<Event>> events() async {
		late final DocumentSnapshot<ObjectMap> snapshot;
		late final Iterable<Subject> subjects;
		await Future.wait([
			Document.events.ref.get().then((s) => snapshot = s),
			this.subjects().then((s) => subjects = s)
		]);

		return snapshot.data()!.entries.map((entry) => EventModel(
			entry,
			subjects: subjects
		));
	}

	Future<Iterable<Subject>> subjects() async {
		final snapshot = await Document.subjects.ref.get();
		return snapshot.data()!.entries.map((entry) => SubjectModel(entry));
	}
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => const HomeRepository());
