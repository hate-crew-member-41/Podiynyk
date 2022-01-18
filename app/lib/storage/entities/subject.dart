import 'package:podiynyk/storage/cloud.dart' show Cloud;

import 'entity.dart';
import 'event.dart';


typedef SubjectEssence = String;


class Subject implements DetailedEntity, StoredEntity<SubjectEssence> {
	final String id;
	final String name;
	final List<Event> events;

	int? totalEventCount;
	List<String>? info;

	Subject({
		required this.id,
		required this.name,
		required this.events
	});

	@override
	Future<void> addDetails() => Cloud.addSubjectDetails(this);

	@override
	SubjectEssence get essence => name;

	@override
	bool essenceIs(SubjectEssence comparedTo) => name == comparedTo;

	String get eventCountRepr => _eventCountRepr(events.length);

	String get totalEventCountRepr => _eventCountRepr(totalEventCount!);

	String _eventCountRepr(int count) {
		switch (count.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$count events";
		}
	}
}
