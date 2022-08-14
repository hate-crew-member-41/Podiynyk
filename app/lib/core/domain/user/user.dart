import 'package:podiinyk/states/home/domain/entities/event.dart';
import 'package:podiinyk/states/home/domain/entities/message.dart';
import 'package:podiinyk/states/home/domain/entities/student.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';


class User {
	const User({
		required this.id,
		required this.firstName,
		required this.lastName,
		this.info,
		this.groupId,
		this.irrelevantEventIds,
		this.chosenSubjectIds
	});

	final String id;
	final String firstName;
	final String lastName;
	final String? info;
	final String? groupId;
	final Set<String>? irrelevantEventIds;
	final Set<String>? chosenSubjectIds;

	Student get student => Student(
		id: id,
		firstName: firstName,
		lastName: lastName,
		chosenSubjectIds: chosenSubjectIds!
	);

	bool eventIsRelevant(Event event) => !irrelevantEventIds!.contains(event.id);

	bool studies(Subject subject) {
		return subject.isCommon || chosenSubjectIds!.contains(subject.id);
	}

	bool isAuthor(Message message) => id == message.author.id;

	// think: define specific update methods
	User copyWith({
		String? firstName,
		String? lastName,
		required String? info,
		required String? groupId,
		required Set<String>? irrelevantEventIds,
		required Set<String>? chosenSubjectIds
	}) => User(
		id: id,
		firstName: firstName ?? this.firstName,
		lastName: lastName ?? this.lastName,
		info: info,
		groupId: groupId,
		irrelevantEventIds: irrelevantEventIds,
		chosenSubjectIds: chosenSubjectIds
	);
}
