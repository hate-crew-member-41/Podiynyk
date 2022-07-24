import 'package:podiinyk/core/domain/user.dart';

import 'entity.dart';


class Subject extends Entity {
	const Subject({
		required String id,
		required this.name,
		required this.students
	}) :
		super(id: id);

	final String name;
	final Iterable<String>? students;

	// think: rename (isChosen?)
	bool get isCommon => students == null;

	bool get isStudied => isCommon || students!.contains(User.id);

	@override
	int compareTo(covariant Subject other) => name.compareTo(other.name);
}
