import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiinyk/core/domain/user.dart';

import 'object_map.dart';


enum Document {
	events,
	subjects
}

extension ReferencedDocument on Document {
	DocumentReference<ObjectMap> get ref =>
		FirebaseFirestore.instance.collection(name).doc(User.groupId);
}
