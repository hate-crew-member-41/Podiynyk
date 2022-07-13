import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/types/document.dart';
import 'package:podiinyk/core/data/types/object_map.dart';

import '../domain/entities/event.dart';
import '../domain/entities/info.dart';
import '../domain/entities/message.dart';
import '../domain/entities/student.dart';
import '../domain/entities/subject.dart';

import 'models/event.dart';
import 'models/info.dart';
import 'models/message.dart';
import 'models/student.dart';
import 'models/subjects.dart';


// do: failures
// do: capture common logic
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

		return snapshot.data()!.entries.map(
			(entry) => EventModel(entry, subjects: subjects)
		);
	}

	Future<Iterable<Subject>> subjects() async {
		final snapshot = await Document.subjects.ref.get();
		return snapshot.data()!.entries.map(
			(entry) => SubjectModel(entry)
		);
	}

	Future<Iterable<Info>> info() async {
		final snapshot = await Document.info.ref.get();
		return snapshot.data()!.entries.map(
			(entry) => InfoModel(entry)
		);
	}

	Future<Iterable<Message>> messages() async {
		late final DocumentSnapshot<ObjectMap> snapshot;
		late final Iterable<Student> students;
		await Future.wait([
			Document.messages.ref.get().then((s) => snapshot = s),
			this.students().then((s) => students = s)
		]);

		return snapshot.data()!.entries.map(
			(entry) => MessageModel(entry, students: students)
		);
	}

	Future<Iterable<Student>> students() async {
		final snapshot = await Document.students.ref.get();
		return snapshot.data()!.entries.map(
			(entry) => StudentModel(entry)
		);
	}
}

final homeRepositoryProvider = Provider<HomeRepository>(
	(ref) => const HomeRepository()
);
