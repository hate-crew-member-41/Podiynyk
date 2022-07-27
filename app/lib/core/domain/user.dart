import 'package:podiinyk/features/home/domain/entities/subject.dart';


// do: change after authentication
class User {
	static const id = 'userId';
	static const name = 'Name';
	static const surname = 'Surname';
	static const groupId = 'groupId';
	// think: rename
	static const chosenSubjectIds = <String>{};

	static bool studies(Subject subject) {
		return subject.isCommon || chosenSubjectIds.contains(subject.id);
	}
}
