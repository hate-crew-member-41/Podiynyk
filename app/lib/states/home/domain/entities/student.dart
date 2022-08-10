import 'entity.dart';
import 'subject.dart';


class Student extends Entity {
	const Student({
		required String id,
		required this.firstName,
		required this.lastName,
		required this.chosenSubjectIds
	}) :
		super(id: id);

	final String firstName;
	final String lastName;
	// think: remove after the data layer is improved (only include this in the StudentDetails)
	final Set<String> chosenSubjectIds;

	String get fullName => '$firstName $lastName';

	bool chose(Subject subject) => chosenSubjectIds.contains(subject.id);

	@override
	int compareTo(covariant Student other) => lastName.compareTo(other.lastName);
}


class StudentDetails {
	const StudentDetails({
		this.info,
		required this.subjects
	});

	final String? info;
	final Iterable<Subject> subjects;

	StudentDetails withSubjects(Iterable<Subject> subjects) => StudentDetails(
		info: info,
		subjects: subjects
	);
}
