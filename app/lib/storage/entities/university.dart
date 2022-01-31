import 'package:podiynyk/storage/cloud.dart' show Cloud;
import 'package:podiynyk/storage/entities/department.dart';


class University {
	final String id;
	final String name;
	
	const University({
		required this.id,
		required this.name
	});

	Future<List<Department>> get departments => Cloud.departments(this);
}
