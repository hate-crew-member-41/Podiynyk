import 'package:podiinyk/core/data/types/field.dart';

import '../../domain/entities/info.dart';


class InfoModel extends Info {
	InfoModel(MapEntry<String, dynamic> entry) : super(
		id: entry.key,
		name: entry.value[Field.name.name],
		content: entry.value[Field.content.name]
	);
}
