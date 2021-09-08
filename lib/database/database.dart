import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities/role.dart';
import 'entities/groupmate.dart';
import 'entities/event.dart';
import 'entities/info_record.dart';
import 'models/user.dart';
import 'models/group.dart';
import 'models/appearance.dart';


class Database {
	late FirebaseFirestore _cloud;
	final user = User(), appearance = Appearance();
	late Group group;

	Database() { this.group = Group(user); }

	Future<void> open(context) async {
		await Future.wait([
			Firebase.initializeApp().then((_) {
				_cloud = FirebaseFirestore.instance;
			}),
			// Hive.initFlutter().then((_) => Future.wait([
			// 	user.open(), group.open(), appearance.open()
			// ]))
			Hive.initFlutter()
			.then((_) => Hive.deleteBoxFromDisk('user'))
			.then((_) => Hive.deleteBoxFromDisk('appearance'))
			.then((_) => Hive.deleteBoxFromDisk('group'))
			.then((_) => Hive.deleteBoxFromDisk('groupCollections'))
			.then((_) => Future.wait([
				user.open(), group.open(), appearance.open()
			]))
		]);

		for (var adapter in <TypeAdapter>[
			RoleAdapter(), GroupmateAdapter(), EventAdapter(), InfoRecordAdapter()
		]) Hive.registerAdapter<dynamic>(adapter);

		if (!group.id.isSet) await appearance.initialize(context);
	}

	Future<Map<String, String>> heis() async {
		DocumentSnapshot<Map<String, dynamic>> index = await _cloud.doc('HEIs/index').get();
		return index.data()!.cast<String, String>();
	}

	Future<Map<String, String>> departments(String heiId) async {
		DocumentSnapshot<Map<String, dynamic>> hei = await _cloud.doc('HEIs/$heiId').get();
		return hei['departments'];
	}
}
