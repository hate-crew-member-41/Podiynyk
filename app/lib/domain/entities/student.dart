import 'package:podiinyk/data/types.dart';


class Student {
	const Student({
		required this.id,
		required this.name,
		required this.surname,
		this.info
	});

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
