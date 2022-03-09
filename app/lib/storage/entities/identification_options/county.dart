import '../../cloud.dart';

import 'identification_option.dart';
import 'university.dart';


class County extends IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	
	County({
		required this.id,
		required this.name
	});

	Future<List<University>> get universities => Cloud.universities(this);
}
