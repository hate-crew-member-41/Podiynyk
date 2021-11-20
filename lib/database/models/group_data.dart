import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiynyk/database/entities/groupmate.dart' show Groupmate;
import 'package:podiynyk/database/entities/role.dart' show Role;
import 'package:podiynyk/database/entities/subject.dart';

import 'user.dart';


class GroupData {
	GroupData() {
		if (User.groupId != null) _syncUserRole();
	}

	Future<void> _syncUserRole() async {
		var students = await _collection('students').get();
		int roleIndex = int.parse(students[User.name]);
		User.role = Role.values[roleIndex];
	}

	static DocumentReference<Map<String, dynamic>> _collection(String name) => FirebaseFirestore.instance.doc(
		'$name/${User.groupId!}'
	);

	static Future<List<Subject>> subjects() async {
		var rawSubjects = await _collection('subjects').get();
		var subjects = rawSubjects.data()!.cast<String, Map<String, dynamic>>();

		var labels = User.subjectLabels;

		labels.keys.where(
			(name) => !subjects.containsKey(name)
		).forEach((name) {
			User.removeSubjectLabel(name);
		});

		return subjects.entries.map<Subject>((subject) => Subject(
			id: subject.key,
			name: subject.value['name'],
			label: labels[subject.key],
			eventCount: subject.value['now'],
			totalEventCount: subject.value['total']
		)).toList();
	}

	static Future<List<Groupmate>> groupmates() async {
		var rawGroupmates = await _collection('students').get();
		var groupmates = rawGroupmates.data()!.cast<String, String>();
		groupmates.remove(User.name);

		var labels = User.studentLabels;

		labels.keys.where(
			(name) => !groupmates.containsKey(name)
		).forEach((name) {
			User.removeStudentLabel(name);
		});

		return groupmates.entries.map<Groupmate>((groupmate) => Groupmate(
			name: groupmate.key,
			role: Role.values[int.parse(groupmate.value)],
			label: labels[groupmate.key]
		)).toList();
	}

	static Future<void> changeRole(String name, Role role) => _collection('students').update({
		name: role.index.toString()
	});

	static Future<void> makeLeader(String name) => _collection('students').update({
		name: Role.leader.index.toString(),
		User.name: Role.trusted.index.toString()
	});
}
