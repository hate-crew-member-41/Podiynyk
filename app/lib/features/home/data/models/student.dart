import 'package:podiinyk/core/data/types/field.dart';

import '../../domain/entities/student.dart';


class StudentModel extends Student {
	StudentModel(MapEntry<String, dynamic> entry) : super(
		id: entry.key,
		name: entry.value[Field.name.name][0],
		surname: entry.value[Field.name.name][1]
	);
}
