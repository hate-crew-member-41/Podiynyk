class Student {
	const Student({
		required this.id,
		required this.name,
		required this.surname
	});

	final String id;
	final String name;
	final String surname;

	String get fullName => '$name $surname';
}
