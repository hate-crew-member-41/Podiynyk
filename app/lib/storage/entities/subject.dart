import '../cloud.dart';
import '../fields.dart';
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

	late final bool isFollowed;

	final List<SubjectInfo>? info;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name
	};
	@override
	CloudMap get detailsInCloudFormat => {
		Identifier.info.name: {
			for (final item in info!) item.id: item.inCloudFormat
		}
	};

	@override
	Future<Subject> get withDetails async => Subject._withDetails(
		subject: this,
		details: await Cloud.entityDetails(this)
	);

	@override
	EntityCollection get cloudCollection => EntityCollection.subjects;
	@override
	Identifier get labelCollection => Identifier.subjects;
}
