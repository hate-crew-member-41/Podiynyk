import 'identification_option.dart';


class Department extends IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	
	Department({
		required this.id,
		required this.name,
	});
}
