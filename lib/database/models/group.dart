import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/role.dart' show Role;
import '../entities/subject.dart';
import '../entities/groupmate.dart' show Groupmate;
import 'user.dart';


class Group {
	late Box<dynamic> _box;

	final User _user;
	late GroupId id;

	Group(this._user);

	String? get edu => _box.get('edu');
	set edu(String? edu) => _box.put('edu', edu);

	String? get department => _box.get('department');
	set department(String? department) => _box.put('department', department);

	String? get name => _box.get('name');
	set name(String? name) => _box.put('name', name);

	Future<void> open() async {
	 	await Hive.openBox<dynamic>('group').then( (box) => _box = box );
		id = GroupId(_box);
	}

	DocumentReference<Map<String, dynamic>> _collection(String collection) {
		return FirebaseFirestore.instance.doc('$collection/$id');
	}

	Future<void> syncUserRole() async {
		DocumentSnapshot<Map<String, dynamic>> students = await _collection('students').get();
		int roleIndex = int.parse(students[_user.name]);
		_user.role = Role.values[roleIndex];
	}

	Future<List<Subject>> subjects() async {
		DocumentSnapshot<Map<String, dynamic>> collection = await _collection('subjects').get();
		// return collection.data()!.entries.map<Subject>((subject) => Subject(
		// 	id: subject.key,
		// 	name: subject.value['name'],
		// 	numEvents: subject.value['now'],
		// 	numEventsSoFar: subject.value['total']
		// )).toList();
	}

	Future<List<Groupmate>> groupmates() async {
		DocumentSnapshot<Map<String, dynamic>> students = await _collection('students').get();
		Map<String, String> groupmates = students.data()!.cast<String, String>();
		groupmates.remove(_user.name);

		Map<String, String> labels = _user.studentLabels;

		labels.keys.where(
			(name) => !groupmates.containsKey(name)
		).forEach((name) {
			_user.removeLabel(name);
		});

		return groupmates.entries.map<Groupmate>((groupmate) => Groupmate(
			name: groupmate.key,
			role: Role.values[int.parse(groupmate.value)],
			label: labels[groupmate.key]
		)).toList();
	}

	Future<void> changeRole(String name, Role role) => _collection('students').update({
		'students.$name': role.index.toString()
	});

	Future<void> makeLeader(String name) => _collection('students').update({
		'students.$name': Role.leader.index.toString(),
		'students.${_user.name}': Role.trusted.index.toString()
	});
}


class GroupId {
	final Box<dynamic> _box;
	GroupId(this._box);

	// bool get isSet => _box.get('id') != null;
  // temporary, until the registration process is done
	bool get isSet => true;

	String get eduId => _box.get('eduId');
	set eduId(String id) {
		_box.put('eduId', id);
	}

	String get departmentId => _box.get('departmentId');
	set departmentId(String id) {
		_box.put('departmentId', id);
	}

	String get pureName => _box.get('name').toLowerCase().replaceAll(' ', '').replaceAll('-', '');

	Future<void> init() => _box.put('id', '$eduId.$departmentId.$pureName');

	// @override
	// String toString() => _box.get('id');
  // temporary, until the registration process is done
	@override
	String toString() => '0.16.ів92';
}
