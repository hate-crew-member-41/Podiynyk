import 'package:podiinyk/states/home/domain/entities/message.dart';
import 'package:podiinyk/states/home/domain/entities/subject.dart';


class User {
	const User({
		required this.id,
		required this.name,
		required this.surname,
		this.groupId,
		this.chosenSubjectIds
	});

	final String id;
	final String name;
	final String surname;
	final String? groupId;
	final Set<String>? chosenSubjectIds;

	bool studies(Subject subject) {
		return subject.isCommon || chosenSubjectIds!.contains(subject.id);
	}

	bool isAuthor(Message message) => id == message.author.id;

	User copyWith({
		required String? groupId,
		required Set<String>? chosenSubjectIds
	}) => User(
		id: id,
		name: name,
		surname: surname,
		groupId: groupId,
		chosenSubjectIds: chosenSubjectIds
	);
}
