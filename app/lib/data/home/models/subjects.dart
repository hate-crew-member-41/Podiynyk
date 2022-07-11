import 'package:podiinyk/domain/home/entities/subject.dart';

import '../../core/types/field.dart';


class SubjectModel extends Subject {
	SubjectModel(MapEntry<String, dynamic> entry) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		isCommon: entry.value[Field.isCommon.name]
	);
}
