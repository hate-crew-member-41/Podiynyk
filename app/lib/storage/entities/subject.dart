import '../cloud.dart' show Cloud;
import '../fields.dart';
import '../local.dart';
import 'event.dart';


class Subject {
	final String id;
	final String name;
	late bool isFollowed;
	final List<Event>? events;

	int? totalEventCount;
	List<String>? info;

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {bool events = true}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		events = events ? <Event>[] : null
	{
		isFollowed = Local.subjectIsFollowed(this);
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
		isFollowed = false;
		Local.unfollowSubject(this);
	}

	void follow() {
		isFollowed = true;
		Local.followSubject(this);
	}

	String get essence => name;

}
