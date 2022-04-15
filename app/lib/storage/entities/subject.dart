import '../cloud.dart';
import '../identifier.dart';
import '../local.dart';

import 'entity.dart';
import 'subject_info.dart';


class Subject extends Entity {
	Subject({
		required String name
	}) :
		info = const <SubjectInfo>[],
		isFollowed = true,
		super.created(name: name);

	Subject.fromCloud({required String id, required CloudMap object}) :
		info = null,
		super.fromCloud(id: id, object: object)
	{
		isFollowed = !Local.entityIsStored(Identifier.unfollowedSubjects, this);
	}

	Subject.ofEvent(CloudMap object) :
		info = null,
		super.fromObject(object)
	{
		isFollowed = !Local.entityIsStored(Identifier.unfollowedSubjects, this);
	}

	Subject._withDetails({
		required Subject subject,
		required CloudMap details
	}) :
		isFollowed = subject.isFollowed,
		info = [
			for (final entry in details[Identifier.info.name].entries) SubjectInfo.fromCloud(
				id: entry.key,
				object: entry.value
			)
		]..sort(),
		super.withDetails(entity: subject);

	Subject.modified(Subject subject, {
		String? nameRepr,
		bool? followed,
		List<SubjectInfo>? info
	}) :
		isFollowed = followed ?? subject.isFollowed,
		info = info ?? subject.info,
		super.modified(subject, nameRepr: nameRepr)
	{
		if (followed == false) {
			Local.storeEntity(Identifier.unfollowedSubjects, this);
		}
		else if (followed == true) {
			Local.deleteEntity(Identifier.unfollowedSubjects, this);
		}
	}

	late final bool isFollowed;

	final List<SubjectInfo>? info;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name
	};
	@override
	CloudMap get detailsInCloudFormat => {
		Identifier.info.name: {
			for (final item in info!)
				item.id: item.inCloudFormat
		}
	};

	@override
	Future<Subject> get withDetails async => Subject._withDetails(
		subject: this,
		details: await Cloud.entityDetails(this)
	);

	@override
	Collection get cloudCollection => Collection.subjects;
	@override
	Identifier get labelCollection => Identifier.subjects;
}
