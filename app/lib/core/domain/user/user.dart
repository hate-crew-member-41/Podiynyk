import 'package:podiinyk/states/home/domain/entities/message.dart';
import 'package:podiinyk/states/home/domain/entities/student.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';


class User {
	const User({
		required this.id,
		required this.firstName,
		required this.lastName,
		this.groupId,
		this.chosenSubjectIds
	});

	final String id;
	final String firstName;
	final String lastName;
	final String? groupId;
	final Set<String>? chosenSubjectIds;

	Student get student => Student(
		id: id,
		firstName: firstName,
		lastName: lastName,
		chosenSubjectIds: chosenSubjectIds!
	);

	bool studies(Subject subject) {
		return subject.isCommon || chosenSubjectIds!.contains(subject.id);
	}

	bool isAuthor(Message message) => id == message.author.id;

	User copyWith({
		required String? groupId,
		required Set<String>? chosenSubjectIds
	}) => User(
		id: id,
		firstName: firstName,
		lastName: lastName,
		groupId: groupId,
		chosenSubjectIds: chosenSubjectIds
	);
}
