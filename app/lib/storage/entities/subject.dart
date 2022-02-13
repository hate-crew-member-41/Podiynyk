import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';


class Subject {
	final String id;
	final String name;
	late bool isFollowed;
	late final List<Event> events;

	List<SubjectInfo>? info;

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.events}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String
	{
		isFollowed = Local.entityIsUnstored(Field.unfollowedSubjects, name);
	}

	static String nameFromCloudFormat(MapEntry<String, dynamic> entry) {
		return entry.value[Field.name.name] as String;
	}

	Future<void> addDetails() => Cloud.addSubjectDetails(this);

	String get eventCountRepr {
		final eventCount = events.length;
		switch (eventCount.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$eventCount events";
		}
	}

	static bool withNameIsFollowed(String name) => Local.entityIsUnstored(Field.unfollowedSubjects, name);

	void unfollow() {
		Local.storeEntity(Field.unfollowedSubjects, name);
		isFollowed = false;
	}

	void follow() {
		Local.deleteEntity(Field.unfollowedSubjects, name);
		isFollowed = true;
	}
}


class SubjectInfo {
	final String topic;
	final String info;

	SubjectInfo({
		required this.topic,
		required this.info
	});

	SubjectInfo.fromCloudFormat(dynamic object) :
		topic = object[Field.topic.name]!,
		info = object[Field.info.name]!;
	
	Map<String, String> get inCloudFormat => {
		Field.topic.name: topic,
		Field.info.name: info
	};
}
