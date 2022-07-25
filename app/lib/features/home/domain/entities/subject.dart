import 'package:podiinyk/core/domain/user.dart';

import 'entity.dart';
import 'info.dart';
import 'student.dart';


class Subject extends Entity {
	const Subject({
		required String id,
		required this.name,
		required this.studentIds
	}) :
		super(id: id);

	final String name;
	final Iterable<String>? studentIds;

	// think: rename (isChosen?)
	bool get isCommon => studentIds == null;

	bool get isStudied => isCommon || studentIds!.contains(User.id);

	@override
	int compareTo(covariant Subject other) => name.compareTo(other.name);
}

// do: define copyWith
class SubjectDetails {
	const SubjectDetails({
		required this.info,
		this.students
	});

	final Iterable<Info> info;
	final Iterable<Student>? students;

	SubjectDetails withInfo(Iterable<Info> info) => SubjectDetails(
		info: info,
		students: students
	);
}
