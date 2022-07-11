import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/types/document.dart';
import 'package:podiinyk/core/data/types/object_map.dart';

import '../domain/entities/event.dart';
import '../domain/entities/info.dart';
import '../domain/entities/subject.dart';

import 'models/event.dart';
import 'models/info.dart';
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

		return snapshot.data()!.entries.map((entry) => EventModel(entry, subjects: subjects));
	}

	Future<Iterable<Subject>> subjects() async {
		final snapshot = await Document.subjects.ref.get();
		return snapshot.data()!.entries.map((entry) => SubjectModel(entry));
	}

	Future<Iterable<Info>> info() async {
		final snapshot = await Document.info.ref.get();
		return snapshot.data()!.entries.map((entry) => InfoModel(entry));
	}
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => const HomeRepository());
