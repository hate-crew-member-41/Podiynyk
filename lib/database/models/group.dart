import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/role.dart' show Role;
import '../entities/subject.dart';
import '../entities/groupmate.dart' show Groupmate;
import 'user.dart';


class Group {
	late Box<dynamic> _box;
	// late Box<List> _collectionsBox;
	final User _user;
	late GroupId id;

	Group(this._user);


	String? get edu => _box.get('edu');
	set edu(String? edu) => _box.put('edu', edu);

	String? get department => _box.get('department');
	set department(String? department) => _box.put('department', department);

	String? get name => _box.get('name');
	set name(String? name) => _box.put('name', name);

	// bool get leaderIsDetermined {
	// 	for (Groupmate groupmate in groupmates) {
	// 		if (groupmate.role == Role.leader) return true;
	// 	}
	// 	return false;
	// }

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
		return collection.data()!.entries.map<Subject>((subject) => Subject(
			id: subject.key,
			name: subject.value['name'],
			numEvents: subject.value['now'],
			numEventsSoFar: subject.value['total']
		)).toList();
	}

	Future<List<Groupmate>> groupmates() async {
		DocumentSnapshot<Map<String, dynamic>> students = await _collection('students').get();
		Map<String, String> groupmates = students.data()!.cast<String, String>();
		groupmates.remove(_user.name);

		Map<String, String> labels = _user.labels;
		Iterable<String> missingStudents = labels.keys.where( (name) => !groupmates.containsValue(name) );
		for (var name in missingStudents) _user.removeLabel(name);

		return groupmates.entries.map<Groupmate>((groupmate) => Groupmate(
			name: groupmate.key,
			role: Role.values[int.parse(groupmate.value)],
			label: labels[groupmate.key]
		)).toList();
	}

	// List<Event> get events {
	// 	List<dynamic>? events = _collectionsBox.get('events');
	// 	return (events != null) ? events.cast<Event>() : <Event>[];
	// }
	// List<InfoRecord> get info {
	// 	List<dynamic>? info = _collectionsBox.get('info');
	// 	return (info != null) ? info.cast<InfoRecord>() : <InfoRecord>[];
	// }
	// List<Groupmate> get groupmates {
	// 	List<dynamic>? groupmates = _collectionsBox.get('groupmates');
	// 	return (groupmates != null) ? groupmates.cast<Groupmate>() : <Groupmate>[];
	// }
	
	// Map<String, List> get data => _collectionsBox.toMap().cast<String, List>();

	// DocumentReference<Map<String, dynamic>> get _document => FirebaseFirestore.instance.doc('groups/$id');
	// Stream<DocumentSnapshot<Map<String, dynamic>>> get updates => _document.snapshots();

	// Future<bool> sync() async {
	// 	DocumentSnapshot<Map<String, dynamic>> cloudData = await _document.get();

	// 	await Future.wait<void>([
	// 		_box.putAll({
	// 			'sync': DateTime.now(),
	// 			'eventsCreated': cloudData['eventsCreated']
	// 		}),
	// 		_collectionsBox.putAll(_localFormatCollections(cloudData))
	// 	]);
	// 	_user.sync(cloudData);

	// 	return !cloudData.metadata.isFromCache;
	// }

	// Map<String, List> _localFormatCollections(DocumentSnapshot<Map<String, dynamic>> cloudData) => <String, List>{
	// 	'groupmates': _localFormatGroupmates(cloudData['students'].cast<String, String>()),
	// 	'events': _localFormatEvents(cloudData['events'].cast<int, List<dynamic>>()),
	// 	'info': _localFormatInfo(cloudData['info'].cast<String, String>())
	// };

	// List<Groupmate> _localFormatGroupmates(Map<String, String> cloudStudents) {
	// 	//	cloudStudents = <String, String>{
	// 	//		String studentName: String studentRole,
	// 	//		...
	// 	//	}
	// 	cloudStudents.remove(_user.name);
	// 	List<Groupmate> newGroupmates = cloudStudents.entries.map<Groupmate>((groupmate) {
	// 		String name = groupmate.key;
	// 		Role role = Role.values[int.parse(groupmate.value)];
	// 		String? label;

	// 		for (Groupmate groupmate in groupmates) if (groupmate.name == name) {
	// 			label = groupmate.label;
	// 			break;
	// 		}

	// 		return Groupmate(name, role, label);
	// 	}).toList();

	// 	// todo: sort newGroupmates

	// 	return newGroupmates;
	// }

	// List<Event> _localFormatEvents(Map<int, List<dynamic>> cloudEvents) => cloudEvents.entries.map<Event>((event) {
	// 	//	cloudEvents = <int, List<dynamic>>{
	// 	//		int eventId: [
	// 	//			String eventContent, DateTime eventDatetime, String? eventNote
	// 	//		],
	// 	//		...
	// 	//	}
	// 	int id = event.key;
	// 	String content = event.value[0];
	// 	DateTime datetime = event.value[1];
	// 	String? note = event.value[2];
	// 	String? group;

	// 	for (Event event in events) if (event.id == id) {
	// 		group = event.group;
	// 		break;
	// 	}

	// 	return Event(id, content, datetime, note, group);
	// }).toList();
	
	// List<InfoRecord> _localFormatInfo(Map<String, String> cloudInfo) => cloudInfo.entries.map<InfoRecord>((infoRecord) {
		//	cloudInfo = <String, String>{
		//		String infoRecordTitle: String infoRecordContent,
		//		...
		//	}
	// 	String title = infoRecord.key;
	// 	String content = infoRecord.value;
	// 	String? group;

	// 	for (InfoRecord infoRecord in info) if (infoRecord.title == title) {
	// 		group = infoRecord.group;
	// 		break;
	// 	}

	// 	return InfoRecord(title, content, group);
	// }).toList();

	Future<void> endIdentification() async {
		await id.set();
		// todo: register properly
		// await _document.update({ 'students.${_user.name}': Role.ordinary.index.toString() });
		// await sync();
		// if (!leaderHasBeenDetermined) await _document.update({ 'confirmations.${_user.name}': 0 });
	}

	Future<void> changeRole(String name, Role role) => _collection('students').update({
		'students.${name}': role.index.toString()
	});

	Future<void> makeLeader(String name) => _collection('students').update({
		'students.${name}': Role.leader.index.toString(),
		'students.${_user.name}': Role.trusted.index.toString()
	});
}


class GroupId {
	final Box<dynamic> _box;
	GroupId(this._box);

	bool get isSet => _box.get('id') != null;

	String get eduId => _box.get('eduId');
	set eduId(String id) {
		_box.put('eduId', id);
	}

	String get departmentId => _box.get('departmentId');
	set departmentId(String id) {
		_box.put('departmentId', id);
	}

	String get pureName => _box.get('name').toLowerCase().replaceAll(' ', '').replaceAll('-', '');

	Future<void> set() => _box.put('id', '$eduId.$departmentId.$pureName');

	@override
	String toString() => _box.get('id');
}
