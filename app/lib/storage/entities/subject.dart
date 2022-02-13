import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity {
	final String id;
	late bool isFollowed;
	late final List<Event> events;

	List<SubjectInfo>? info;

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.events}) :
		id = entry.key,
		super(initialName: entry.value[Field.name.name] as String)
	{
		isFollowed = Local.entityIsUnstored(Field.unfollowedSubjects, essence);
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
}


class SubjectInfo extends LabelableEntity {
	final String info;

	SubjectInfo({
		required String topic,
		required this.info
	}) : super(initialName: topic);

	SubjectInfo.fromCloudFormat(dynamic object) :
		info = object[Field.info.name] as String,
		super(initialName: object[Field.topic.name] as String);
	
	Map<String, String> get inCloudFormat => {
		Field.topic.name: initialName,
		Field.info.name: info
	};
	
	@override
	Field get labelCollection => Field.subjectInfo;
}
