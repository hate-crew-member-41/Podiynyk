import 'entity.dart';


class Student  extends Entity {
	const Student({
		required String id,
		required this.name,
		required this.surname
	}) :
		super(id: id);

	final String name;
	final String surname;

	String get fullName => '$name $surname';

	@override
	int compareTo(covariant Student other) => surname.compareTo(other.surname);
}
