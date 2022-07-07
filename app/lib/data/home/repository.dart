import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/data/core/types/identifier.dart';

import 'package:podiinyk/domain/core/user.dart';
import 'package:podiinyk/domain/home/entities/event.dart';
import 'package:podiinyk/domain/home/entities/subject.dart';


// do: cache documents
class HomeRepository {
	const HomeRepository();

	// do: failures
	Future<Iterable<Event>> events() async {
		final docs = await Future.wait([
			FirebaseFirestore.instance
				.collection(Identifier.events.name)
				.doc(User.groupId).get(),
			FirebaseFirestore.instance
				.collection(Identifier.subjects.name)
				.doc(User.groupId).get()
		]);
		final eventsDoc = docs[0].data()!, subjectsDoc = docs[1].data()!;

		final subjects = {
			for (final entry in subjectsDoc.entries) entry.key : Subject.fromCloud(
				id: entry.key,
				object: entry.value
			)
		};

		return eventsDoc.entries.map((entry) => Event.fromCloud(
			id: entry.key,
			object: entry.value,
			subjects: subjects
		));
	}
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) => const HomeRepository());
