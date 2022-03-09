import '../../cloud.dart';

import 'identification_option.dart';
import 'department.dart';


class University extends IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	
	University({
		required this.id,
		required this.name
	});

	Future<List<Department>> get departments => Cloud.departments(this);
}
