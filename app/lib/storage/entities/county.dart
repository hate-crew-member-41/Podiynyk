import '../cloud.dart' show Cloud;

import 'identification_option.dart';
import 'university.dart';


class County implements IdentificationOption {
	@override
	final String id;
	@override
	final String name;
	
	const County({
		required this.id,
		required this.name
	});

	Future<List<University>> get universities => Cloud.universities(this);
}
