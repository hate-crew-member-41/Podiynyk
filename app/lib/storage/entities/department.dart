import 'identification_option.dart';


class Department implements IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	
	const Department({
		required this.id,
		required this.name,
	});
}
