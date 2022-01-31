import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/university.dart';


class County {
	final String id;
	final String name;
	
	const County({
		required this.id,
		required this.name
	});

	Future<List<University>> get universities => Cloud.universities(this);
}
