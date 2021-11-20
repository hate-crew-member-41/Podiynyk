import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:podiynyk/database/models/appearance.dart';
import 'package:podiynyk/database/models/user.dart';

import 'package:podiynyk/database/entities/event.dart';
import 'package:podiynyk/database/entities/groupmate.dart';
import 'package:podiynyk/database/entities/info_record.dart';
import 'package:podiynyk/database/entities/role.dart';


class Database {
	static late FirebaseFirestore _cloud;
	
	static Future<void> open(BuildContext context) async {
		_registerLocalAdapters();
		await _initDatabases(context);
	}

	static void _registerLocalAdapters() {
		Hive.registerAdapter(RoleAdapter());
		Hive.registerAdapter(GroupmateAdapter());
		Hive.registerAdapter(EventAdapter());
		Hive.registerAdapter(InfoRecordAdapter());
	}

	static Future<void> _initDatabases(BuildContext context) => Future.wait([
		Firebase.initializeApp().then((_) {
			_cloud = FirebaseFirestore.instance;
		}),
		Hive.initFlutter().then((_) => Future.wait([
			User.open(), Appearance.open(context)
		]))
	]);

	static Future<Map<String, String>> heis() async {
		DocumentSnapshot<Map<String, dynamic>> index = await _cloud.doc('HEIs/index').get();
		return index.data()!.cast<String, String>();
	}

	static Future<Map<String, String>> departments(String heiId) async {
		DocumentSnapshot<Map<String, dynamic>> hei = await _cloud.doc('HEIs/$heiId').get();
		return hei['departments'];
	}
}
