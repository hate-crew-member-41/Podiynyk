import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'creatable.dart';
import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity implements CreatableEntity, Comparable {
	late final List<Event>? events;
	List<SubjectInfo>? info;

	Subject({required String name}) : super(
		idComponents: [name],
		name: name
	);

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {this.events}) : super.fromCloud(
		id: entry.key,
		name: entry.value[Field.name.name] as String
	);

	static String nameFromCloudFormat(MapEntry<String, dynamic> entry) => entry.value[Field.name.name];

	@override
	CloudMap get inCloudFormat => {Field.name.name: name};

	@override
	CloudMap get detailsInCloudFormat => {Field.info.name: <String, Map<String, String>>{}};

	bool get isFollowed => !Local.entityIsStored(Field.unfollowedSubjects, id);
	set isFollowed(bool isFollowed) {
		!isFollowed ? Local.storeEntity(Field.unfollowedSubjects, id) : Local.deleteEntity(Field.unfollowedSubjects, id);
	}

	Future<void> addDetails() async {
		final details = await Cloud.entityDetails(Collection.subjects, id);
		info = [
			for (final entry in details[Field.info.name].entries) SubjectInfo.fromCloudFormat(entry, subject: this)
		]..sort();
		Local.clearEntityLabels(Field.subjectInfo, info!);
	}

	void addInfo(SubjectInfo item) {
		info!.add(item);
		Cloud.updateSubjectInfo(this, item);
	}

	void deleteInfo(SubjectInfo item) {
		info!.remove(item);
		Cloud.deleteSubjectInfo(this, item);
	}

	static bool withNameIsFollowed(String name) => !Local.entityIsStored(Field.unfollowedSubjects, name);

	String get eventCountRepr {
		final eventCount = events!.length;
		switch (eventCount.compareTo(1)) {
			case -1: return "no events";
			case 0: return "1 event";
			default: return "$eventCount events";
		}
	}

	@override
	Field get labelCollection => Field.subjects;

	@override
	int compareTo(covariant Subject other) => nameRepr.compareTo(other.nameRepr);
}


class SubjectInfo extends LabelableEntity implements Comparable {
	final Subject subject;

	SubjectInfo({
		required this.subject,
		required String name,
		required content
	}) :
		_content = content,
		super(
			idComponents: [subject.name, name],
			name: name
		);
	
	SubjectInfo.fromCloudFormat(dynamic entry, {required this.subject}) :
		_content = entry.value[Field.content.name] as String,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);

	Map<String, String> get inCloudFormat => {
		Field.name.name: name,
		Field.content.name: content
	};

	String _content;
	String get content => _content;
	set content(String content) {
		_content = content;
		Cloud.updateSubjectInfo(subject, this);
	}

	void delete() => subject.deleteInfo(this);

	@override
	Field get labelCollection => Field.subjectInfo;

	@override
	int compareTo(covariant SubjectInfo other) => nameRepr.compareTo(other.nameRepr);
}
