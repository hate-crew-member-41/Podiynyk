import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

import '../entities/role.dart' show Role;
import '../entities/subject.dart';
import '../entities/groupmate.dart' show Groupmate;


class GroupData {
	final User _user;

	GroupData(this._user) {
		if (_user.groupId != null) _syncUserRole();
	}

	DocumentReference<Map<String, dynamic>> _collection(String collection) {
		return FirebaseFirestore.instance.doc('$collection/${_user.groupId!}');
	}

	Future<void> _syncUserRole() async {
		var students = await _collection('students').get();
		int roleIndex = int.parse(students[_user.name]);
		_user.role = Role.values[roleIndex];
	}

	Future<List<Subject>> subjects() async {
		var rawSubjects = await _collection('subjects').get();
		var subjects = rawSubjects.data()!.cast<String, Map<String, dynamic>>();

		var labels = _user.subjectLabels;

		labels.keys.where(
			(name) => !subjects.containsKey(name)
		).forEach((name) {
			_user.removeSubjectLabel(name);
		});

		return subjects.entries.map<Subject>((subject) => Subject(
			id: subject.key,
			name: subject.value['name'],
			label: labels[subject.key],
			eventCount: subject.value['now'],
			totalEventCount: subject.value['total']
		)).toList();
	}

	Future<List<Groupmate>> groupmates() async {
		var rawGroupmates = await _collection('students').get();
		var groupmates = rawGroupmates.data()!.cast<String, String>();
		groupmates.remove(_user.name);

		var labels = _user.studentLabels;

		labels.keys.where(
			(name) => !groupmates.containsKey(name)
		).forEach((name) {
			_user.removeStudentLabel(name);
		});

		return groupmates.entries.map<Groupmate>((groupmate) => Groupmate(
			name: groupmate.key,
			role: Role.values[int.parse(groupmate.value)],
			label: labels[groupmate.key]
		)).toList();
	}
}
