import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';
import 'entity.dart';


class Subject implements StoredEntity {
	final String id;
	final String name;
	late bool isFollowed;
	final List<Event>? events;

	int? totalEventCount;
	List<SubjectInfo>? info;

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {bool events = true}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		events = events ? <Event>[] : null
	{
		isFollowed = Local.entityIsUnstored(Field.unfollowedSubjects, this);
	}

	Future<void> addDetails() => Cloud.addSubjectDetails(this);

	String get eventCountRepr => _eventCountRepr(events!.length);

	String get totalEventCountRepr => _eventCountRepr(totalEventCount!);

	String _eventCountRepr(int count) {
		switch (count.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$count events";
		}
	}

	void unfollow() {
		Local.storeEntity(Field.unfollowedSubjects, this);
		isFollowed = false;
	}

	void follow() {
		Local.deleteEntity(Field.unfollowedSubjects, this);
		isFollowed = true;
	}

	@override
	String get essence => name;

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
