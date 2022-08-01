import 'entity.dart';
import 'subject.dart';


class Student extends Entity {
	const Student({
		required String id,
		required this.name,
		required this.surname,
		required this.chosenSubjectIds
	}) :
		super(id: id);

	// think: rename to first, last
	final String name;
	final String surname;
	// think: remove after the data layer is improved (only include this in the StudentDetails)
	final Set<String> chosenSubjectIds;

	String get fullName => '$name $surname';

	bool chose(Subject subject) => chosenSubjectIds.contains(subject.id);

	@override
	int compareTo(covariant Student other) => surname.compareTo(other.surname);
}
