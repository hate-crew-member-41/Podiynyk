import '../cloud.dart' show Cloud;
import '../fields.dart';
import 'event.dart';


typedef SubjectEssence = String;


class Subject {
	final String id;
	final String name;
	final List<Event>? events;

	int? totalEventCount;
	List<String>? info;

	// todo: add a default value for events
	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {bool events = true}) :
		id = entry.key,
		name = entry.value[Field.name.name] as String,
		events = events ? <Event>[] : null;

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
}
