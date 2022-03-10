import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity implements Comparable {
	late final List<Event> events;
	List<SubjectInfo>? info;

	Subject({required String name}) : super(name: name);

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {required this.events}) :
		super(name: entry.value[Field.name.name] as String)
	{
		_isFollowed = !Local.entityIsStored(Field.unfollowedSubjects, id);
	}

	static String nameFromCloudFormat(MapEntry<String, dynamic> entry) => entry.value[Field.name.name];

	CloudMap get inCloudFormat => {Field.name.name: name};

	CloudMap get detailsInCloudFormat => {Field.info.name: <SubjectInfo>[]};

	late bool _isFollowed;
	bool get isFollowed => _isFollowed;
	set isFollowed(bool isFollowed) {
		_isFollowed = isFollowed;
		!_isFollowed ? Local.storeEntity(Field.unfollowedSubjects, id) : Local.deleteEntity(Field.unfollowedSubjects, id);
	}

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
	List<dynamic> get idComponents => [name];
	
	@override
	Field get labelCollection => Field.subjects;

	@override
	int compareTo(covariant Subject other) => nameRepr.compareTo(other.nameRepr);
}


// think: add id
class SubjectInfo extends LabelableEntity implements Comparable {
	final Subject subject;

	SubjectInfo({
		required this.subject,
		required String name,
		required content
	}) :
		_content = content,
		super(name: name);

	String _content;
	String get content => _content;
	set content(String content) {
		_content = content;
		Cloud.updateSubjectInfo(subject);
	}

	SubjectInfo.fromCloudFormat(dynamic object, {required this.subject}) :
		_content = object[Field.content.name] as String,
		super(name: object[Field.name.name] as String);

	Map<String, String> get inCloudFormat => {
		Field.name.name: name,
		Field.content.name: content
	};

	void delete() => subject.deleteInfo(this);

	@override
	List<dynamic> get idComponents => [subject.name, name];

	@override
	Field get labelCollection => Field.subjectInfo;

	@override
	int compareTo(covariant SubjectInfo other) => nameRepr.compareTo(other.nameRepr);
}
