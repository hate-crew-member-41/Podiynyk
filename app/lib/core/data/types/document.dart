import 'package:cloud_firestore/cloud_firestore.dart';

import 'object_map.dart';


enum Document {
	events,
	info,
	messages,
	students,
	subjects;

	DocumentReference<ObjectMap> ref({required String groupId}) {
		return FirebaseFirestore.instance.collection(name).doc(groupId);
	}
}
