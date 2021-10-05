import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user.dart';
import 'models/group.dart';
import 'models/appearance.dart';

import 'entities/role.dart';
import 'entities/groupmate.dart';
import 'entities/event.dart';
import 'entities/info_record.dart';


class Database {
	late FirebaseFirestore _cloud;
	final user = User(), appearance = Appearance();
	late Group group;

	Database() {
		this.group = Group(user);
	}

	Future<void> open(context) async {
		await Future.wait([
			Firebase.initializeApp().then((_) {
				_cloud = FirebaseFirestore.instance;
			}),
			Hive.initFlutter().then((_) => Future.wait([  // todo: consider keeping them closed when possible
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
