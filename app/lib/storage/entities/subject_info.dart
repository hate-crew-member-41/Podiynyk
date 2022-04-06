import '../cloud.dart' show CloudMap;
import '../identifier.dart';

import 'entity.dart';


class SubjectInfo extends Entity {
	SubjectInfo({
		required String name,
		required this.content
	}) :
		super.created(name: name);
	
	SubjectInfo.fromCloud({required String id, required CloudMap object}) :
		content = object[Identifier.content.name] as String,
		super.fromCloud(id: id, object: object);
	
	SubjectInfo.modified({
		required SubjectInfo info,
		String? nameRepr,
		String? content
	}) :
		content = content ?? info.content,
		super.modified(entity: info, nameRepr: nameRepr);

	final String content;

	@override
	CloudMap get inCloudFormat => {
		Identifier.name.name: name,
		Identifier.content.name: content
	};

	@override
	Identifier get labelCollection => Identifier.subjectInfo;
}
