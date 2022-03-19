import '../cloud.dart';
import '../fields.dart';
import '../local.dart';

import 'creatable.dart';
import 'event.dart';
import 'labelable.dart';


class Subject extends LabelableEntity implements CreatableEntity, Comparable {
	Subject({required String name}) :
		events = <Event>[],
		info = <SubjectInfo>[],
		_hasDetails = true,
		super(
			idComponents: [name],
			name: name
		);

	Subject.fromCloudFormat(MapEntry<String, dynamic> entry, {this.events}) :
		_hasDetails = false,
		super.fromCloud(
			id: entry.key,
			name: entry.value[Field.name.name] as String
		);

	Subject.name({required String name}) :
		events = null,
		_hasDetails = false,
		super(
			idComponents: [name],
			name: name
		);

	final List<Event>? events;
	List<SubjectInfo>? info;

	bool _hasDetails;
	bool get hasDetails => _hasDetails;

	bool get isFollowed => !Local.entityIsStored(Field.unfollowedSubjects, id);
	set isFollowed(bool isFollowed) {
		!isFollowed ? Local.storeEntity(Field.unfollowedSubjects, id) : Local.deleteEntity(Field.unfollowedSubjects, id);
	}

	String get eventCountRepr {
		final eventCount = events!.length;
		switch (eventCount) {
			case 0: return "no events";
			case 1: return "1 event";
			default: return "$eventCount events";
		}
	}

	Future<void> addDetails() async {
		if (_hasDetails) return;

		final details = await Cloud.entityDetails(Collection.subjects, id);
		info = [
			for (final entry in details[Field.info.name].entries) SubjectInfo.fromCloudFormat(entry, subject: this)
		]..sort();
		_hasDetails = true;

		Local.clearEntityLabels(Field.subjectInfo, info!);
	}

	Future<void> addEvent(Event event) async {
		
	}

	Future<void> addInfo(SubjectInfo item) async {
		info!.add(item);
		await Cloud.updateSubjectInfo(this, item);
	}

	Future<void> deleteInfo(SubjectInfo item) async {
		info!.remove(item);
		await Cloud.deleteSubjectInfo(this, item);
	}

	@override
	CloudMap get inCloudFormat => {Field.name.name: name};

	@override
	CloudMap get detailsInCloudFormat => {Field.info.name: <String, Map<String, String>>{}};

	@override
	Field get labelCollection => Field.subjects;

	@override
	int compareTo(covariant Subject other) => nameRepr.compareTo(other.nameRepr);
}


class SubjectInfo extends LabelableEntity implements Comparable {
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
	
	final Subject subject;

	String _content;
	String get content => _content;
	set content(String content) {
		if (content.isEmpty) return;
		_content = content;
		Cloud.updateSubjectInfo(subject, this);
	}

	void delete() => subject.deleteInfo(this);

	Map<String, String> get inCloudFormat => {
		Field.name.name: name,
		Field.content.name: content
	};

	@override
	Field get labelCollection => Field.subjectInfo;

	@override
	int compareTo(covariant SubjectInfo other) => nameRepr.compareTo(other.nameRepr);
}
