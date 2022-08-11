import 'package:cloud_firestore/cloud_firestore.dart';

import 'types/object_map.dart';


DocumentReference<ObjectMap> userDocRef(String id) {
	return FirebaseFirestore.instance.collection('users').doc(id);
}
