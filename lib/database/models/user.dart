import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/role.dart' show Role;


class User {
	late Box<dynamic> _detailsBox;
	late Box<String> _labelsBox;

	String get name => _detailsBox.get('name');
	set name(String name) => _detailsBox.put('name', name);
	
	Role get role => _detailsBox.get('role');
	set role(Role role) => _detailsBox.put('role', role);

	Map<String, String> get labels => _labelsBox.toMap().cast<String, String>();

	// bool? get claimsToBeLeader => _detailsBox.get('claims');
	// set claimsToBeLeader(bool? claims) => _detailsBox.put('claims', claims);

	Future<void> open() async {
		List<dynamic> boxes = await Future.wait([
			Hive.openBox<dynamic>('user'),
			Hive.openBox<String>('labels')
		]);
		_detailsBox = boxes[0];
		_labelsBox = boxes[1];
	}

	Future<void> removeLabel(String name) => _labelsBox.delete(name);

	// void sync(DocumentSnapshot<Map<String, dynamic>> cloudData) {
	// 	var roleIndex = int.parse(cloudData['students'].remove(name)!);
	// 	// tofix: for whatever reason, it throws _TypeError(type Groupmate is not a subtype of Role),
	// 	// so it thinks that Role.values[roleIndex] is Groupmate, which is impossible since List<Role>[int] is Role
	// 	// _box.put('role', Role.values[roleIndex]);
	// }
}
