import 'package:hive/hive.dart';

import '../entities/role.dart' show Role;


class User {
	late Box<dynamic> _detailsBox;
	late Box<String> _studentLabelsBox;
	late Box<String> _subjectLabelsBox;

	String get name => _detailsBox.get('name');
	set name(String name) => _detailsBox.put('name', name);

	// String? get groupId => _detailsBox.get('groupId');
	// temporary, until the identification process is implemented
	String? get groupId => '0.16.ів92';

	Role get role => _detailsBox.get('role');
	set role(Role role) => _detailsBox.put('role', role);

	Map<String, String> get studentLabels => _studentLabelsBox.toMap().cast<String, String>();

	Future<void> removeStudentLabel(String name) => _studentLabelsBox.delete(name);

	Map<String, String> get subjectLabels => _subjectLabelsBox.toMap().cast<String, String>();

	Future<void> removeSubjectLabel(String name) => _studentLabelsBox.delete(name);

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

	Future<void> initGroupId(String heiId, String departmentId, String groupName) {
		String pureGroupName = groupName.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
		return _detailsBox.put('groupId', '$heiId.$departmentId.$pureGroupName');
	}
}
