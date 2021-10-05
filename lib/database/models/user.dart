import 'package:hive/hive.dart';

import '../entities/role.dart' show Role;


class User {
	late Box<dynamic> _detailsBox;
	late Box<String> _studentLabelsBox;
	late Box<String> _subjectLabelsBox;

	String get name => _detailsBox.get('name');
	set name(String name) => _detailsBox.put('name', name);
	
	Role get role => _detailsBox.get('role');
	set role(Role role) => _detailsBox.put('role', role);

	Map<String, String> get studentLabels => _studentLabelsBox.toMap().cast<String, String>();

	Map<String, String> get subjectLabels => _subjectLabelsBox.toMap().cast<String, String>();

	Future<void> open() async {
		List<dynamic> boxes = await Future.wait([
			Hive.openBox<dynamic>('user'),
			Hive.openBox<String>('studentLabels'),
			Hive.openBox<String>('subjectLabels')
		]);
		_detailsBox = boxes[0];
		_studentLabelsBox = boxes[1];
		_subjectLabelsBox = boxes[2];
	}

	Future<void> removeLabel(String name) => _studentLabelsBox.delete(name);
}
