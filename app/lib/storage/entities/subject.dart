import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity implements Comparable {
	final String id;
	late bool isFollowed;
	late final List<Event> events;

	List<SubjectInfo>? info;

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.events}) :
		id = entry.key,
		super(initialName: entry.value[Field.name.name] as String)
	{
		isFollowed = !Local.entityIsStored(Field.unfollowedSubjects, essence);
	}

	static String nameFromCloudFormat(MapEntry<String, dynamic> entry) {
		return entry.value[Field.name.name] as String;
	}

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.subjects, id);
		info = [
			for (final object in details[Field.info.name]) SubjectInfo.fromCloudFormat(object)
		]..sort();
	}

	String get eventCountRepr {
		final eventCount = events.length;
		switch (eventCount.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$eventCount events";
		}
	}

	static bool withNameIsFollowed(String name) => !Local.entityIsStored(Field.unfollowedSubjects, name);

	@override
	Field get labelCollection => Field.subjects;

	void unfollow() {
		Local.storeEntity(Field.unfollowedSubjects, essence);
		isFollowed = false;
	}

	void follow() {
		Local.deleteEntity(Field.unfollowedSubjects, essence);
		isFollowed = true;
	}

	@override
	String get essence => initialName;

	@override
	int compareTo(dynamic other) => name.compareTo(other.name);
}


class SubjectInfo extends LabelableEntity {
	String content;

	SubjectInfo({
		required String name,
		required this.content
	}) : super(initialName: name);

	SubjectInfo.fromCloudFormat(dynamic object) :
		content = object[Field.content.name] as String,
		super(initialName: object[Field.name.name] as String);
	
	Map<String, String> get inCloudFormat => {
		Field.name.name: initialName,
		Field.content.name: content
	};

	@override
	Field get labelCollection => Field.subjectInfo;
}
