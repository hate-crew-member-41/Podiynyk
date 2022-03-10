import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'creatable.dart';
import 'entity.dart';


class Message extends Entity implements CreatableEntity, Comparable {
	final DateTime date;
	String author;

	Message({
		required String name,
		required String content
	}) :
		_name = name,
		_content = content,
		author = Local.name,
		date = DateTime.now(),
		super(idComponents: [Local.name, name]);

	Message.fromCloudFormat(MapEntry<String, dynamic> entry) :
		_name = entry.value[Field.name.name] as String,
		date = (entry.value[Field.date.name] as Timestamp).toDate(),
		author = entry.value[Field.author.name] as String,
		super.fromCloud(id: entry.key);

	@override
	CloudMap get inCloudFormat => {
		Field.name.name: name,
		Field.date.name: date,
		Field.author.name: author
	};

	@override
	CloudMap get detailsInCloudFormat => {
		Field.content.name: content
	};

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

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.messages, id);
		content = details[Field.content.name];
	}

	@override
	int compareTo(covariant Message other) => other.date.compareTo(date);
}
