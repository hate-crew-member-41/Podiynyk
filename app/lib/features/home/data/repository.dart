import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:podiinyk/core/data/types/document.dart';
import 'package:podiinyk/core/data/types/field.dart';
import 'package:podiinyk/core/data/types/object_map.dart';
import 'package:podiinyk/core/domain/types/date.dart';

import '../domain/entities/event.dart';
import '../domain/entities/info.dart';
import '../domain/entities/message.dart';
import '../domain/entities/student.dart';
import '../domain/entities/subject.dart';


// do: failures
// do: define addEntity, entities
// do: prevent unnecessary reads
class HomeRepository {
	const HomeRepository();

	Future<void> addEvent(Event event) async {
		await Document.events.ref.update({
			event.id: {
				Field.name.name: event.name,
				if (event.subject != null) Field.subject.name: event.subject?.id,
				Field.date.name: event.date.value,
				Field.hasTime.name: event.date.hasTime,
				if (event.note != null) Field.note.name: event.note
			}
		});
	}

	Future<void> addSubject(Subject subject) async {
		await Document.subjects.ref.update({
			subject.id: {
				Field.name.name: subject.name,
				if (subject.students != null) Field.students.name: subject.students
			}
		});
	}

	Future<void> addInfo(Info item) async {
		await Document.info.ref.update({
			item.id: {
				Field.name.name: item.name,
				Field.content.name: item.content
			}
		});
	}

	Future<void> addMessage(Message message) async {
		await Document.messages.ref.update({
			message.id: {
				Field.name.name: message.name,
				Field.content.name: message.content,
				Field.author.name: message.author.id,
				Field.date.name: message.date.value
			}
		});
	}

	Future<Iterable<Event>> events() async {
		late final DocumentSnapshot<ObjectMap> snapshot;
		late final Iterable<Subject> subjects;
		await Future.wait([
			Document.events.ref.get().then((s) => snapshot = s),
			this.subjects().then((s) => subjects = s)
		]);

		return snapshot.data()!.entries.map((entry) => Event(
			id: entry.key,
			name: entry.value[Field.name.name],
			subject: entry.value.containsKey(Field.subject.name) ?
				subjects.firstWhere((s) => s.id == entry.value[Field.subject.name]) :
				null,
			date: Date(
				(entry.value[Field.date.name] as Timestamp).toDate(),
				hasTime: entry.value[Field.hasTime.name]
			),
			note: entry.value[Field.note.name]
		));
	}

	Future<Iterable<Subject>> subjects() async {
		final snapshot = await Document.subjects.ref.get();
		return snapshot.data()!.entries.map((entry) => Subject(
			id: entry.key,
			name: entry.value[Field.name.name],
			students: !entry.value.containsKey(Field.students.name) ?
				null :
				List<String>.from(entry.value[Field.students.name])
		));
	}

	Future<Iterable<Info>> info() async {
		final snapshot = await Document.info.ref.get();
		return snapshot.data()!.entries.map((entry) => Info(
			id: entry.key,
			name: entry.value[Field.name.name],
			content: entry.value[Field.content.name]
		));
	}

	Future<Iterable<Message>> messages() async {
		late final DocumentSnapshot<ObjectMap> snapshot;
		late final Iterable<Student> students;
		await Future.wait([
			Document.messages.ref.get().then((s) => snapshot = s),
			this.students().then((s) => students = s)
		]);

		return snapshot.data()!.entries.map((entry) => Message(
			id: entry.key,
			name: entry.value[Field.name.name],
			content: entry.value[Field.content.name],
			author: students.firstWhere((s) => s.id == entry.value[Field.author.name]),
			date: Date((entry.value[Field.date.name] as Timestamp).toDate())
		));
	}

	Future<Iterable<Student>> students() async {
		final snapshot = await Document.students.ref.get();
		return snapshot.data()!.entries.map((entry) => Student(
			id: entry.key,
			name: (entry.value[Field.name.name] as List<String>).first,
			surname: (entry.value[Field.name.name] as List<String>).last
		));
	}
}

final homeRepositoryProvider = Provider<HomeRepository>(
	(ref) => const HomeRepository()
);
