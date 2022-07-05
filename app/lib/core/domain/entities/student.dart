import '../../types/field.dart';
import '../../types/object_map.dart';


class Student {
	// do: redefine
	const Student.user() :
		id = 'id',
		name = 'Name',
		surname = 'Surname',
		info = null;

	Student.fromCloud({
		required this.id,
		required ObjectMap object
	}) :
		name = object[Field.name.name],
		surname = object[Field.surname.name],
		info = null;

	final String id;
	final String name;
	final String surname;
	final StudentDetails? info;
}

class StudentDetails {
	const StudentDetails({
		this.info
	});

	final String? info;
}
