import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';


class Message implements Comparable {
	final String id;
	final DateTime date;
	String? author;

	String _name;
	String get name => _name;
	set name(String name) {
		_name = name;
		Cloud.updateMessageName(this);
	}

	String? _content;
	String? get content => _content;
	set content(String? content) {
		_content = content;
		Cloud.updateMessageContent(this);
	}

	Message.fromCloudFormat(MapEntry<String, dynamic> entry) :
		id = entry.key,
		_name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate();

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.messages, id);
		content = details[Field.content.name];
		author = details[Field.author.name];
	}

	@override
	int compareTo(dynamic other) => other.date.compareTo(date);
}
