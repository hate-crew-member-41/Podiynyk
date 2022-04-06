import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:podiynyk/storage/cloud.dart';
import 'package:podiynyk/storage/identifier.dart';


class Candidate implements Comparable {
	Candidate.fromCloud({required this.id, required CloudMap object}) :
		name = object[Identifier.name.name] as String,
		confirmationCount = object[Identifier.confirmationCount.name] as int,
		joinedTime = (object[Identifier.joinedTime.name] as Timestamp).toDate();
	
	final String id;
	final String name;
	final int confirmationCount;
	final DateTime joinedTime;

	@override
	int compareTo(covariant Candidate other) => joinedTime.compareTo(other.joinedTime);
}
