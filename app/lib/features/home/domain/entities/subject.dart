import 'entity.dart';


class Subject extends Entity {
	const Subject({
		required String id,
		required this.name,
		required this.isCommon
	}) :
		super(id: id);

	final String name;
	final bool isCommon;

	@override
	int compareTo(covariant Subject other) => name.compareTo(other.name);
}
