
import 'identification_option.dart';
import 'university.dart';


class Department implements IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	final University university;
	
	const Department({
		required this.id,
		required this.name,
		required this.university
	});
}
