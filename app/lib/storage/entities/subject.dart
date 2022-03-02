import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity implements Comparable {
	final String id;
	late final List<Event> events;
	List<SubjectInfo>? info;

	late bool _isFollowed;
	bool get isFollowed => _isFollowed;
	set isFollowed(bool isFollowed) {
		_isFollowed = isFollowed;
		!_isFollowed ? Local.storeEntity(Field.unfollowedSubjects, essence) : Local.deleteEntity(Field.unfollowedSubjects, essence);
	}

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.events}) :
		id = entry.key,
		super(initialName: entry.value[Field.name.name] as String)
	{
		_isFollowed = !Local.entityIsStored(Field.unfollowedSubjects, essence);
	}

	static String nameFromCloudFormat(MapEntry<String, dynamic> entry) => entry.value[Field.name.name];

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.subjects, id);
		info = [
			for (final object in details[Field.info.name]) SubjectInfo.fromCloudFormat(object, subject: this)
		]..sort();
		Local.clearEntityLabels(Field.subjectInfo, info!);
	}

	String get eventCountRepr {
		final eventCount = events.length;
		switch (eventCount.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$eventCount events";
		}
	}

	void deleteInfo(SubjectInfo item) {
		info!.remove(item);
		Cloud.updateSubjectInfo(this);
	}

	static bool withNameIsFollowed(String name) => !Local.entityIsStored(Field.unfollowedSubjects, name);

	@override
	Field get labelCollection => Field.subjects;

	@override
	String get essence => initialName;

	@override
	int compareTo(dynamic other) => name.compareTo(other.name);
}


class SubjectInfo extends LabelableEntity implements Comparable {
	final Subject subject;

	String _content;
	String get content => _content;
	set content(String content) {
		_content = content;
		Cloud.updateSubjectInfo(subject);
	}

	SubjectInfo({
		required this.subject,
		required String name,
		required content
	}) :
		_content = content,
		super(initialName: name);

	SubjectInfo.fromCloudFormat(dynamic object, {required this.subject}) :
		_content = object[Field.content.name] as String,
		super(initialName: object[Field.name.name] as String);

	Map<String, String> get inCloudFormat => {
		Field.name.name: initialName,
		Field.content.name: content
	};

	void delete() => subject.deleteInfo(this);

	@override
	Field get labelCollection => Field.subjectInfo;

	@override
	int compareTo(dynamic other) => name.compareTo(other.name);
}
