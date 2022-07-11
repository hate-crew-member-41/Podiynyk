import 'package:podiinyk/core/data/types/field.dart';

import '../../domain/entities/subject.dart';


class SubjectModel extends Subject {
	SubjectModel(MapEntry<String, dynamic> entry) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		isCommon: entry.value[Field.isCommon.name]
	);
}
