import 'entity.dart';
import 'info.dart';
import 'student.dart';


class Subject extends Entity {
	const Subject({
		required String id,
		required this.name,
		required this.isCommon
	}) :
		super(id: id);

	final String name;
	// think: rename (isChosen / isGeneral / isObligatory)
	final bool isCommon;

	@override
	int compareTo(covariant Subject other) => name.compareTo(other.name);
}


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
