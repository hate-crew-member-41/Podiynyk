import 'package:hive/hive.dart';

import 'package:podiynyk/database/entities/role.dart' show Role;


class User {
	static late Box<dynamic> _detailsBox;
	static late Box<String> _studentLabelsBox;
	static late Box<String> _subjectLabelsBox;

	static set name(String name) => _detailsBox.put('name', name);
	static String get name => _detailsBox.get('name');

	// static String? get groupId => _detailsBox.get('groupId');
	// temporary, until the identification process is implemented
	static String? get groupId => '0.16.ів92';

	// static Role get role => _detailsBox.get('role');
	static Role get role => Role.leader;
	static set role(Role role) => _detailsBox.put('role', role);

	static Map<String, String> get studentLabels => _studentLabelsBox.toMap().cast<String, String>();

	static Future<void> removeStudentLabel(String name) => _studentLabelsBox.delete(name);

	static Map<String, String> get subjectLabels => _subjectLabelsBox.toMap().cast<String, String>();

	static Future<void> removeSubjectLabel(String name) => _studentLabelsBox.delete(name);

	static Future<void> open() async {
		List<dynamic> boxes = await Future.wait([
			Hive.openBox<dynamic>('user'),
			Hive.openBox<String>('studentLabels'),
			Hive.openBox<String>('subjectLabels')
		]);
		
		_detailsBox = boxes[0];
		_studentLabelsBox = boxes[1];
		_subjectLabelsBox = boxes[2];
	}

	static Future<void> initGroupId(String heiId, String departmentId, String groupName) {
		String pureGroupName = groupName.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
		return _detailsBox.put('groupId', '$heiId.$departmentId.$pureGroupName');
	}
}
